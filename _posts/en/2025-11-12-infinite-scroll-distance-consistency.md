---
categories:
- frontend
- ux
- virtualization
date: 2025-11-12
layout: post
permalink: /en/2025/11/12/infinite-scroll-distance-consistency.html
tags:
- Infinite Scrolling
- Pagination
- User Experience
- Memory Management
- Data Consistency
title: Ideation on Infinite Scrolling and Scroll Depth Alignment
---

> `gpt-4-turbo` has translated this article into English.

---

# Ideation on Infinite Scroll and Scroll Distance Alignment

## 🧭 Overview

Infinite scrolling provides users with a seamless navigation experience.  
However, there exists a subtle mismatch between the physical scroll distance and the actual position of data.  
This article explores **how to maintain alignment between scroll distance and data** in an infinite scroll environment,  
and organizes personal thoughts on making the user experience natural and the system consistent.

---

## 1. The Challenges of Alignment in Infinite Scroll

Infinite scrolling is based on two uncertainties: asynchronous loading and dynamic height changes.  
When each item has a different rendering height or when images, ads, or content load late,  
the scroll position does not directly correspond to the data index.

In this process, the following phenomena are often observed:

- Failure to restore scroll position  
- Height jumps during loading  
- Difficulty in handling jumps to data not yet loaded  
- Discontinuities involving missing or duplicate data  

These issues are not solved by simple viewport control or virtual lists,  
ultimately touching on the fundamental theme of “consistency between data and position.”

---

## 2. A Structure to be Considered Together by Server and Client

Alignment is hard to achieve by efforts from just one side.

**On the server side**:
- A clear and stable sorting criterion is necessary (e.g., combination of createdAt + id).
- Cursor-based pagination must ensure idempotency and order.
- A snapshotId that allows continuous requests based on the same time point is helpful.
- Providing rendering hints (such as estimated height) can aid the client in distance calculations.

**On the client side**:
- Manage scroll position as a data anchor.
- Set a safe window to control the range of loading and unloading.
- Tie data, cursor, and height information into a single snapshot to maintain a consistent state.

When the server and client recognize each other's roles,  
the balance between scroll distance and data alignment seems to become clearer.

---

## 3. The Snapshot Model for Scroll Alignment

When thinking about alignment, I often return to the question, **"Can we maintain the state of the data loaded so far as a single coordinate system?"**  
Thus, I envisaged a structure called a snapshot.  
A snapshot is understood not merely as a cache, but as a **"logical coordinate system connecting data and physical position."**

### Components of a Snapshot

A snapshot includes the following information:

- `items`: An array of loaded data (order guaranteed)
- `cursors`: Cursor information for requesting previous and next pages
- `estimatedHeights`: Estimated height for each item  
- `measuredHeights`: Heights measured after rendering
- `cumulativeHeights`: Cumulative height sum up to the i-th item
- `totalScrollableHeight`: Total scrollable height
- `anchorId`, `anchorOffset`: Position anchor based on the screen center or top
- `meta`: Metadata for judging validity such as filters, sorting, version, timestamp

### Operation of a Snapshot

1. **At the initial load point**  
   Upon receiving the first page, set estimated heights for each item and calculate cumulative heights.  
   The total scroll height at this point is an approximation.

2. **Rendering and adjustment phase**  
   After rendering, `measuredHeights` updates `estimatedHeights`.  
   Recalculate cumulative heights for subsequent items to gradually reduce errors.  
   Users experience this change almost imperceptibly as a natural flow.

3. **Management during scroll movement**  
   While scrolling, use `cumulativeHeights` to quickly search for the item index corresponding to scrollTop.  
   This can be calculated with a cost of O(log n),  
   which feels like a useful approach for ensuring the performance stability of infinite scrolling.

4. **Anchor-based restoration**  
   When returning from a different screen,  
   restore the previous position using `anchorId` and `anchorOffset`.  
   As long as the data order is maintained, the restoration works visually stably.

### Significance of a Snapshot

A snapshot is understood not just as a local cache but as a  
"structural unit for reproducing the screen state at a certain point."  
Assuming such a structure, infinite scrolling can be viewed not just as a simple loading pattern but as a system that preserves the context of a feed over time.

---

## 4. The Problem of Jumping to Unloaded Sections

In infinite scrolling, **jumps to areas not yet loaded** commonly occur.  
When scrolling quickly or moving to the end of a page,  
the data at that position does not yet exist, so the meaning of scrollTop changes.

Each time I understand this problem,  
the question "What section of actual data does the scroll distance represent?" remains.  
This question needs to be viewed by extending the concept of distance to **a relative coordinate of data, cursor, and time axis, not just pixels**.

---

## 5. Distance-Based Jump Approach (Distance → Data Position Mapping)

When a single scroll movement is very long,  
the system often does not have all the data corresponding to that distance.  
Thus, I considered a method of **estimating the data position based on the size of the scroll movement**.

### Normalization of Distance

Define a normalized distance value based on screen height.  
`jumpVh = |targetScrollTop - currentScrollTop| / viewportHeight`  
This value indicates how many screen lengths the user intends to skip.

For example:
- `jumpVh = 0.5` → About half a screen movement
- `jumpVh = 2` → Jumping two to three pages
- `jumpVh = 8` → Moving to a far-off position

Based on this ratio, different loading strategies can be distinguished.

### Strategies by Distance Sections

| Section | Features | Treatment Method |
|---------|----------|------------------|
| Short range (≤L1) | Within the safe area | Move index based on the current anchor |
| Medium range (L1~L2) | Continuously loadable range | Limit movement to an upper bound |
| Long range (>L2) | Hard jump | Estimate approximate position based on ratio or domain axis |

- Short range movements use cumulative heights to  
  add deltaIndex to the anchor index.  
- Medium range movements limit the movement to a certain range so that  
  the system only extends within a safely manageable area.  
- Long range movements use data ratio or domain axis (e.g., timestamp) instead of pixel-based estimates to  
  approximate the position.  
  If the total data count is N and the scroll ratio is r, then  
  the approximate `targetIndex ≈ N × r` can be interpreted.

### Observations on Domain Axis-Based Jumps

Using a domain unit axis like time or ID can  
more clearly convey the context of movement to users.  
For example, "Move to March 2024 posts" is more meaningful than  
simply moving down 500px.  
This approach helps users intuitively feel "where they currently are."

### Summary of Distance-Based Approach

This approach attempts to dynamically connect **physical distance and logical data position**.  
Although not every jump can be precisely reproduced,  
the method of interpreting data based on the size of the distance allows consideration of both loading efficiency and continuity.

Ultimately, I view scroll alignment not as "precision in pixel units" but as  
"naturalness on a contextual level."

---

## 6. Perceived Quality and Stabilization Techniques from a UX Perspective

Achieving perfect alignment in infinite scrolling is still challenging.  
However, the 'naturalness' perceived by users is influenced more by **continuity, predictability, and visual stability** than by technical accuracy.  
From that perspective, I view the safe window and preloading as  
key tools for stabilizing UX quality.

### 6.1 Safe Window (safe window)

The safe window refers to the loading range secured in advance around the current viewport.  
Even if users scroll quickly,  
this area allows for immediate rendering of data.

- The upper safe area prevents loading delays when quickly returning to a previous scroll position.  
- The lower safe area provides leeway until the next section is loaded.  
- If the area is too wide, memory and computational costs increase, so  
  dynamically adjusting it based on the screen height ratio is necessary.

In real environments, adjusting the size of the safe area gradually based on network delays, user scroll speed,  
and device performance seems to lead to the highest perceived quality.

### 6.2 Preloading (preloading)

Preloading involves requesting or rendering the next content before it enters the user's view.  
It is particularly effective for elements with high loading costs, such as images, videos, and ads.

- **Short-range preloading**: Fetches data for the next page in advance.  
- **Context-based preloading**: Predictively loads only necessary sections based on scroll direction, speed, and patterns.  
- **Priority adjustment**: If network resources are limited,  
  prioritize content adjacent to the current viewport.

Preloading directly affects the maintenance of visual smoothness.  
Even without perfect alignment, it provides an experiential stability that makes the screen always appear ready.

### 6.3 Visual Buffering Devices

- Using **loading placeholders** to secure height changes in advance can  
  reduce the jump sensation when new data arrives.  
- **Skeleton UIs** provide temporary visual stability before the actual content arrives.  
- **Hard jump sections** are temporarily represented as "loading blocks," and  
  naturally replaced once the actual data is ready.  
- **Error sections** should not be quietly hidden but should provide visual feedback,  
  such as "retry guidance blocks" or gray areas.

These visual buffering devices create a perception for users that they are "within a continuous flow,"  
substituting for precise alignment.

### 6.4 Summary

While safe areas and preloading do not completely solve alignment issues,  
they function as buffering structures that respond before users perceive discontinuity.  
Ultimately, the core of UX quality lies not in perfect numerical alignment but in  
maintaining a sense of uninterrupted navigation.

---

## 7. Balancing Data Alignment and Perceived UX

The design of infinite scrolling seems to be about finding a balance between mathematical accuracy and user perception.  
Securing a minimum standard of accuracy through server cursors, snapshot structures, and safe area control, and  
adding a sense of natural movement on top of that feels realistic.

Rather than making alignment an absolute goal,  
maintaining a consistent system within an expected margin of error seems a more effective approach in real environments.

---

## 8. Mindset in Handling Alignment

The alignment of infinite scrolling is not simply a technical issue of matching pixels.  
It is understood as a structural issue that dynamically adjusts the relationship between data, cursor, height, and distance.

Thus, designers prioritize the consistency of flow over the precision of pixels.  
What users perceive is not absolute coordinates, but  
the "continuity of uninterrupted context."

---

## 9. Areas Still Unresolved Despite Efforts

Despite all efforts, achieving complete alignment remains challenging.  
Recognizing this limitation feels like a natural part of the process.

### 9.1 Uncertainty of Asynchronous Data
- If server data changes in real-time, the meaning of calculated heights and cursors changes.  
- Even data from the same time point can change order due to delays or reordering.

### 9.2 Errors in Client Estimates
- Differences accumulate between estimated and actual heights due to image loading or responsive layout changes.

### 9.3 Damage in Intermediate Sections
- Rapid returns after a hard jump may leave intermediate sections empty, losing anchors.  
- If downloaded data is deleted, cumulative height calculations break.

### 9.4 Exceptions in User Operations
- Fast scrolls such as trackpad acceleration exceed loading speeds.  
- Browser scroll restoration behavior varies by environment, making complete consistency difficult to expect.

### 9.5 UX Limitations
- Users hardly notice a position difference of ±10%.  
- Attempts to excessively increase alignment offer little perceived benefit compared to the complexity.

---

## Conclusion

The alignment of infinite scrolling feels more like a continuous adjustment process to provide users with an "uninterrupted flow" rather than pursuing numerical consistency.  
This article organizes personal ideation on that process,  
and I plan to refine these thoughts through more concrete implementations and experiments in the future.