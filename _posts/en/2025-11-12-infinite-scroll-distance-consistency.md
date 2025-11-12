---
date: 2025-11-12
layout: post
permalink: /en/2025/11/12/infinite-scroll-distance-consistency.html
tags:
- Retrospective
title: Ideation on Infinite Scrolling and Scroll Depth Alignment
---

> `gpt-4-turbo` has translated this article into English.

---

# Ideation on Infinite Scrolling and Scroll Distance Alignment

## 🧭 Overview

Infinite scrolling offers users a seamless navigation experience.  
However, there is a subtle mismatch between the physical scroll distance and the actual position of data.  
This article explores methods to **maintain alignment between scroll distance and data** in an infinite scroll environment,  
documenting personal insights on how to make "users scroll naturally and systems operate consistently."

---

## 1. The Alignment Challenges Posed by Infinite Scrolling

Infinite scrolling is predicated on two uncertainties: asynchronous loading and dynamic height changes.  
If each item's rendering height varies, or if images, ads, and content load late,  
the scroll position does not directly correspond to the data index.  

Commonly observed phenomena in this process include:

- Failure to restore the scroll position  
- Height jumps during loading  
- Difficulty in handling jumps to yet-to-be-loaded data  
- Discontinuous sections with missing or duplicated data  

These phenomena are not resolved by simple viewport control or virtual lists alone,  
ultimately touching on the fundamental issue of "consistency between data and position."

---

## 2. A Structure Requiring Consideration of Both Server and Client

Alignment cannot be achieved by the efforts of one side alone.  

**On the server side:**  
- It is necessary to maintain clear and stable sorting criteria (e.g., createdAt + id combination).  
- Cursor-based pagination should ensure idempotence and order.  
- A snapshotId can facilitate continuous requests based on the same moment.  
- Providing rendering hints (such as expected heights) can help clients with distance calculations.  

**On the client side:**  
- Manage the scroll position using data anchors.  
- Set a safe window to control the range of loading and unloading.  
- Maintain a consistent state by bundling data, cursor, and height information into a snapshot.  

When the server and client recognize each other's roles,  
the balance between scroll distance and data alignment becomes clearer.

---

## 3. The Snapshot Model for Scroll Alignment

Whenever considering alignment, the question arises: **"Can the state of data loaded so far be maintained in a single coordinate system?"**  
Thus, the concept of a snapshot was conceived.  
A snapshot is understood not just as simple caching, but as a **"logical coordinate system connecting data and physical position."**

### Components of a Snapshot

A snapshot includes the following information:

- `items`: An array of loaded data (order guaranteed)
- `cursors`: Cursor information for requesting previous and next pages
- `estimatedHeights`: Estimated heights for each item  
- `measuredHeights`: Heights measured after rendering
- `cumulativeHeights`: Cumulative height sum up to the i-th item
- `totalScrollableHeight`: Total scrollable height
- `anchorId`, `anchorOffset`: Position anchor based on the screen center or top
- `meta`: Metadata for validity assessment, such as filters, sorting, version, timestamp

### How the Snapshot Works

1. **Initial Load Point**  
   Upon receiving the first page, set estimated heights for each item and calculate cumulative heights.  
   The total scroll height at this point is approximate.

2. **Rendering and Adjustment Phase**  
   After rendering, `measuredHeights` update `estimatedHeights`.  
   Recalculate cumulative heights for subsequent items to gradually reduce errors.  
   Users experience this change almost imperceptibly, enjoying a natural flow.

3. **Management During Scrolling**  
   While scrolling, `cumulativeHeights` can be used to quickly search for the item index corresponding to scrollTop.  
   This can be calculated at a cost of O(log n),  
   which feels useful for ensuring the performance stability of infinite scrolling.

4. **Anchor-Based Restoration**  
   When returning from a different screen, restore the previous position using `anchorId` and `anchorOffset`.  
   As long as the data order is maintained, restoration works visually stably.

### Significance of the Snapshot

A snapshot is not just a local cache but is understood as a  
"structural unit for reproducing the screen state at a certain point in time."  
With this structure in mind, infinite scrolling can be viewed not just as a simple loading pattern but as a system that preserves the context of a feed that changes over time.

---

## 4. The Issue of Jumping to Unloaded Sections

In infinite scrolling, **scroll jumps to areas not yet loaded** are common.  
When quickly scrolling down or moving to the end of a page,  
the data at that position does not yet exist, so the meaning of scrollTop changes.

This issue brings us back to the question:  
"What section of the actual data does the scroll distance represent?"  
This question necessitates viewing distance as a relative coordinate on the data, cursor, and time axes, rather than just in pixels.

---

## 5. Jump Distance-Based Approach (Distance → Data Position Mapping)

When a single scroll movement is very long,  
the system often does not have all the data corresponding to that distance.  
Hence, the idea of normalizing the scroll movement and estimating the data position based on its magnitude was considered.

### Normalization of Distance

Define a normalized distance value based on the screen height.  
`jumpVh = |targetScrollTop - currentScrollTop| / viewportHeight`  
This value represents how many screens' worth the user intends to skip.

For instance,  
- `jumpVh = 0.5` → about half a screen of movement  
- `jumpVh = 2` → two to three pages' worth of jump  
- `jumpVh = 8` → moving to a far-off position  

This ratio can be used to differentiate loading strategies.

### Strategies by Distance Segment

| Segment | Characteristics | Handling Method |
|---------|-----------------|-----------------|
| Short range (≤L1) | Movement within safe area | Move indices based on current anchor |
| Medium range (L1~L2) | Continuous loading possible | Limit movement to a maximum range |
| Long range (>L2) | Hard jump | Estimate approximate position based on ratio or domain axis |

- Short-range movements utilize cumulative heights to handle by adding deltaIndex to the anchor index.  
- Medium-range movements limit the movement to a certain range,  
  ensuring expansion only within a system-manageable safe area.  
- Long-range movements eschew pixel-based estimates in favor of  
  data ratios or domain axes (e.g., timestamp),  
  roughly interpreting as `targetIndex ≈ N × r`  
  where N is the total number of data points and r is the scroll ratio.

### Observations on Domain Axis-Based Jumps

Using domain units like time or ID as axes  
delivers more explicit context to users.  
For example, the expression "Jump to posts from March 2024"  
is clearer than simply moving down by 500px.  
This approach helps users intuitively feel "where they currently are."

### Summary of Distance-Based Approach

This approach is an attempt to **dynamically connect physical distance with logical data position.**  
While not every jump can be precisely replicated,  
the method of interpreting data based on the size of the distance allows for consideration of both loading efficiency and continuity.

Ultimately, scroll alignment is understood not in terms of "pixel precision" but  
as "naturalness in context."

---

## 6. UX Perspective on Perceived Quality and Stabilization Techniques

Achieving perfect alignment in infinite scrolling remains challenging.  
However, the 'naturalness' perceived by users is influenced more by  
**continuity, predictability, and visual stability** than by technological accuracy.  
From that perspective, I view the safe window and preloading as  
key tools in stabilizing UX quality.

### 6.1 Safe Window (safe window)

The safe window refers to the range of data pre-loaded around the current viewport.  
Even if users scroll quickly,  
data within this area can be rendered immediately.  

- The upper safe area prevents loading delays when quickly scrolling back.  
- The lower safe area provides a buffer until the next section is fully loaded.  
- If the width of the area is too wide, memory and computation costs increase,  
  so a dynamic approach based on screen height ratio is necessary.  

In real environments, adjusting the size of the safe area gradually based on network delays, user scroll speed, and device performance  
seems to result in the highest perceived quality.

### 6.2 Preloading (preloading)

Preloading involves requesting or rendering the next content before it comes into the user's view.  
Elements with high loading costs, such as images, videos, and ads, benefit significantly from this approach.

- **Near-distance preloading**: Fetch data for the immediate next page in advance.  
- **Context-based preloading**: Predictively load only the necessary sections based on scroll direction, speed, and patterns.  
- **Priority adjustment**: When network resources are limited,  
  prioritize content adjacent to the current viewport.  

Preloading directly influences the maintenance of visual smoothness.  
Even without perfect alignment,  
it provides an experiential stability that makes the screen appear "always ready."

### 6.3 Visual Buffering Devices

- Using **loading placeholders** to secure height changes in advance  
  can reduce the jarring effect when new data arrives.  
- **Skeleton UIs** provide temporary visual stability before the actual content is loaded.  
- **Hard jump sections** are temporarily represented as "loading blocks,"  
  replaced naturally once the actual data is ready.  
- **Error sections** should not be quietly hidden but instead provide visual feedback,  
  such as "retry guidance blocks" or gray areas.  

These visual buffering devices  
create a perception for users of being "within a continuous flow,"  
substituting for precise alignment.

### 6.4 Summary

While the safe window and preloading do not completely solve alignment issues,  
they function as buffering structures that allow for response before users perceive discontinuities.  
Ultimately, the core of UX quality lies not in perfect numerical alignment but in  
**maintaining the sensation of seamless navigation.**

---

## 7. Finding the Balance Between Data Alignment and Perceived UX

The design of infinite scrolling seems to be a balancing act between mathematical accuracy and user perception.  
Securing a **minimum standard of accuracy** through server cursors, snapshot structures, and safe area control, and  
adding **natural movement** seems like a realistic approach.  

Rather than making alignment an absolute goal,  
maintaining a consistent system within an expected margin of error seems to be a more effective approach in real environments.

---

## 8. Mindset for Handling Alignment

Alignment in infinite scrolling is not merely a technical issue of matching pixels.  
It is understood as a **structural problem involving dynamic adjustments between data, cursors, heights, and distances.**  

Thus, designers prioritize **consistency of flow over pixel precision**.  
What users perceive is not absolute coordinates, but  
the "continuity of an unbroken context."

---

## 9. Yet Unresolved Areas Despite Efforts

Despite all efforts, achieving complete alignment remains challenging.  
Recognizing these limitations feels naturally appropriate.

### 9.1 Uncertainty of Asynchronous Data
- Server data can change in real-time, altering the meaning of calculated heights and cursors.  
- Even data from the same moment can be reordered due to delays or rearrangements.  

### 9.2 Errors in Client Estimates
- Differences between expected and actual heights accumulate due to image loading or responsive layout changes.  

### 9.3 Damage in Intermediate Sections
- Rapid returns after hard jumps can leave intermediate sections empty, losing anchors.  
- If downloaded data is deleted, cumulative height calculations break.  

### 9.4 Exceptions in User Operations
- Fast scrolls, such as trackpad acceleration, exceed loading speeds.  
- Browser scroll restoration behaviors vary by environment, making full consistency challenging.  

### 9.5 UX Limits
- Users hardly notice position differences of ±10%.  
- Efforts to excessively increase alignment may not yield substantial perceptual benefits relative to complexity.  

---

## Conclusion

The alignment in infinite scrolling feels more like a continuous adjustment process to provide users with a "seamless flow," rather than a pursuit of numerical consistency.  
This article documents personal ideation on that process,  
with plans to refine these thoughts through more concrete implementation and experimentation in the future.