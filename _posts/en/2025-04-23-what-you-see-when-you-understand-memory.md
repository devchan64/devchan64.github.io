---
date: 2025-04-23
layout: post
permalink: /en/2025/04/23/what-you-see-when-you-understand-memory.html
tags:
- Design Philosophy
- Memory Management
title: '"Things You See Once You Understand Memory"'
---

> `gpt-4-turbo` has translated this article into English.

---

# Things You See Once You Understand Memory

> The Hidden Structures and Performance Behind Code
> This article addresses the memory perspective necessary for transitioning from 'someone who writes code' to 'someone who designs systems.'

> "Memory" refers to physical/logical storage space,
> and "memory management" includes the design and operational actions involved in allocating, tracking, and freeing that space.

---

# 1. Why We Need to Discuss Memory

“Isn’t memory something we don’t need to worry about these days?”

Many developers think this way.  
Indeed, most modern languages manage memory automatically, allowing programs to be created without direct memory control in many cases.

However, this notion only means that one **might not experience** the difficulties of memory management, **not that the concept of memory management has disappeared.**

The real issue lies in our attitude of considering memory management as something ‘we don’t need to worry about.’

Consider this scenario:  
One day, a system crash occurs for no apparent reason.  
There are no relevant details in the logs, and monitoring shows nothing unusual. However, memory usage steadily increases.  
Then, someone might say:

> “Shouldn’t the GC handle it?”

Is that really the case? GC is not omnipotent.  
The timing and manner of GC operation, conditions under which objects are not freed, references hanging onto root objects, **are issues that can only be resolved with knowledge.**

Moreover, this is not just a problem with GC languages like Java or Python.  
In C/C++, Rust, embedded environments, **memory management is always at the core of the structure.**

Developers ultimately are the ones who **create** and **design how things operate**.  
For us not to understand memory is like an architect not knowing how concrete sets.

This article discusses memory.  
However, it is not about organizing variables or sharing tips.  
We aim to discuss **what kind of thinking memory enables** and **why understanding memory changes our perspective.**

Knowing memory changes your code.  
And at that moment, **things that were invisible start to become visible.**

---

# 2. The Memory Overlooked Casually

Every developer declares variables, creates objects, and calls functions.  
However, few can precisely recall what processes these actions trigger in memory.

Most development environments are very adept at hiding these processes.  
Python manages reference counts, Java reclaims memory through GC, and JavaScript lets the browser and runtime handle it.  
Thus, we gradually start to develop without being conscious of memory.

Yet, when problems arise or when analyzing performance, we inevitably return to memory.  
Even in unseen moments, memory quietly dictates the operation of the program.

- **Stack** is the space for function calls and local variables.  
  As calls nest, stack frames accumulate and are freed upon return.

- **Heap** is the space for dynamic allocation.  
  Objects created at the developer's request are stored here, and the timing of their release is sometimes unclear.

- **GC (Garbage Collector)** manages the heap area.  
  However, it is difficult to predict which objects will fail to be reclaimed.

- Disconnection of references does not immediately free memory.

## 2.1 Control Units and Stored Programs: Memory is the Starting Point of Execution

Memory is more than just a container for data.  
The **commands** we write, our code, are also stored in memory.

This is the essence of the 'stored-program architecture.'  
Computers store both commands and data in the same memory space.  
The control unit retrieves instructions from this memory and controls the execution flow.

Thus, a program is a **flow of instructions stored** in memory.  
**Understanding memory is fundamentally understanding how a program operates.**

Writing code without understanding memory is like designing an assembly line without seeing how the conveyor belt flows.

Now, we realize that memory is not just a spatial issue but a starting point for **flow, control**, and **structural thinking.**

---

# 3. The True Nature of Code as Revealed by Memory

On the surface, the code functions well.  
There are no errors, and it performs its features accurately.  
However, with prolonged operation or under high user load, the system slows down and may eventually crash.

The problem is not visible.  
The code appears logically perfect.  
Yet, within it, the memory is gradually deteriorating.

## Example 1: Repeated Dynamic Allocations

```python
def append_items():
    result = []
    for _ in range(1000000):
        result.append("item")
    return result
```

- This code repeatedly creates new string objects and adds them to a list.
- If the list is not freed after use, the GC cannot reclaim it, and it remains in memory.
- Temporarily, it might seem fine, but if called repeatedly, the heap increasingly fills up.

## Example 2: Reference Leak in Event Handlers

```javascript
function setup() {
    const el = document.getElementById("btn");
    el.addEventListener("click", () => {
        // Carelessly creating a closure that references an external context
        console.log("clicked");
    });
}
```

- Even if the event is removed, the handler's closure often remains alive with the DOM.
- GC cannot sever this reference link.
- Developers might wonder, "Why is the browser getting slower?"

```java
Map<String, Object> cache = new HashMap<>();
public void load(String key) {
    cache.put(key, new Data()); // Continuously adding without overwriting
}
```

- Continuously adding data to a cache without a removal logic causes memory to increase endlessly.
- Objects piled up in the heap are not targeted by GC.
- This pattern is more dangerous because it appears like 'well-written code' in practice.

These issues can **only be detected by someone who views memory 'structurally'.**
It’s not merely a sense of “something feels slow,” but a line of thought like, **“This object isn’t being freed → GC can’t reclaim it → It’s linked to a root object.”**

At that moment, a developer transitions from simply ‘implementing features’ to '**designing the flow of resources**.'

We now understand.
The difference between what is visible and what is not, lies within memory.

---

# 4. A Shift in Thought: Centering Development Around Memory

So far, we have examined issues such as memory leaks, GC delays, and failure to release references.  
These problems all share a common trait: they are ‘**code that works but is incorrect**’.

Now, we need to change our question.

> From "Why is it wrong?"  
> to "Why should it be structured this way?"

Thinking in terms of memory management is not just a technique for catching bugs.  
**It is a framework that changes the perspective of program design.**

Understanding memory management naturally prompts questions like:

- When should this resource be created and released?
- Who should be responsible for it?
- Is it reusable? Should it be destroyed?
- How does unnecessary retention affect performance?

These are questions that **go beyond writing code** and are considered by **those who design structures.**

## 4.1 Memory Is More Than Just a Place to Hold Data

We've previously discussed the concepts of control units and stored programs.  
Understanding this structure, we realize that memory is not just a space but **the core that supports the program's flow.**

- The control unit fetches and interprets instructions from memory.  
- Instructions are stored together with data in the same space.  
- This stored flow constitutes the program, and the program is a structure designed around this flow.

This shift in thought transforms developers.

Beyond simply naming variables well and organizing logic efficiently,  
we now ask questions like:

- **How does this system recycle resources?**  
- **Is this flow structurally designed?**

At this point, developers are no longer mere implementers but  
**people who design structures.**

And it all starts with a subtle change in perception,  
**revisiting memory.**

---

# 5. Conclusion: When You Understand Memory, Development Changes

Developers are ultimately in a position to **design structures.**  
How to implement which features, how to use which resources in what flow—all these decisions are considered together.

Understanding memory means transcending the stage of merely using structures to  
**designing and taking responsibility for that flow.**

The purpose of this article is not to list memory tuning tips.  
It's to propose a **shift in the developer's perspective, a turning point.**

- Why does the system slow down?  
- Why does GC sometimes not help?  
- Why do codes with the same functionality show performance differences?

All answers **lie on memory.**  
Specifically, depending on **whether you understand memory or not.**

When you understand memory, you see structures instead of codes and flows instead of bugs.

Only then can we move beyond ‘working code’ to ‘designed programs.’

And it all starts with this question.

**“Do you understand memory?”**

---

# Appendix. A Guide for Developers to Understand Memory

This article proposed viewing memory not just as a resource but as a tool for thought.  
However, in practice, memory often appears as **the subject of debugging**, **a bottleneck for performance**, or **a complexity in design**.

This appendix organizes typical memory-related issues into **symptoms, principles, solutions, and tools**, aiming to enhance practical understanding of memory management.

## 1. Memory Leak

**Symptoms**: Over time, memory usage does not decrease but continues to increase, eventually slowing down or shutting down the system.  
**Principle**: Objects that have finished being used are excluded from GC targets or manually allocated memory is not freed, remaining in the heap.  
**Strategies**:  
- Check the local state of functions that are called repeatedly and sever the reference relationships with root objects.  
- Analyze the causes of prolonged object lifespans.  
**Tools**: `Valgrind`, `AddressSanitizer`, `Memory Profiler`

## 2. Invalid Memory Access

**Symptoms**: NullPointerException, segmentation fault, array boundary overflows, and other exceptions occur.  
**Principle**: Invalid pointer, referenced freed object, access beyond boundaries.  
**Strategies**:  
- Thoroughly validate pointer validity and learn reference safety patterns specific to languages.  
- Use automated static analysis tools to detect errors at the coding stage.  
**Tools**: `GDB`, `Valgrind`, `AddressSanitizer`

## 3. Memory Fragmentation

**Symptoms**: Despite having sufficient memory, large allocations fail, or the time for allocation/deallocation progressively lengthens.  
**Principle**: Heap becomes fragmented due to frequently allocated and freed blocks of various sizes.  
**Strategies**:  
- Apply a `Memory Pool` or `Slab Allocator` structure using memory blocks of the same size.  
- Cache or reuse frequently allocated objects.  
**Tools**: Slab Allocator, jemalloc, tcmalloc

## 4. Buffer Overflow

**Symptoms**: Sudden crashes, stack corruption, unexpected behaviors.  
**Principle**: Occurs when data is written beyond the fixed range of an array.  
**Strategies**:  
- Use safe functions (`strncpy`, `snprintf`) and add size checks to all array operations.  
- Activate overflow detection with compiler flags.  
**Tools**: `AddressSanitizer`, `Stack Smashing Protector (SSP)`

## 5. Garbage Collection Issues

**Symptoms**: Intermittent delays, pauses, failure in memory reclamation.  
**Principle**: Objects with unsevered references remain in the GC root and are not reclaimed.  
**Strategies**:  
- Clearly distinguish object reference cycles and utilize `WeakReference`, etc.  
- Analyze GC logs to identify patterns of unreclaimed objects.  
**Tools**: `G1GC`, `VisualVM`, `Memory Analyzer`

## 6. Cache Pollution

**Symptoms**: Increase in cache misses, performance degradation, reduced data locality.  
**Principle**: Frequently unused data enters the cache, displacing frequently used data.  
**Strategies**:  
- Redesign data access order to enhance spatial and temporal locality.  
- Store Hot/Cold data separately and consider structure alignment.  
**Tools**: `Cachegrind`, `Intel VTune`

## 7. Data Race

**Symptoms**: Irregular behavior in a multi-threaded environment, variable values differ from expectations.  
**Principle**: Occurs when two or more threads attempt to write to the same memory simultaneously without synchronization.  
**Strategies**:  
- Protect access to shared resources with `Mutex`, `Lock`, `Atomic`, etc.  
- Document the scope and ownership of locks and detect race conditions in tests.  
**Tools**: `Helgrind`, `ThreadSanitizer`, `Concurrency Visualizer`

## Conclusion

This guide is structured not merely as a list of tools but as a  
**perspective on recognizing problems → an attitude of understanding structures → a strategy for solutions.**

> Understanding memory management means ultimately controlling the flow of the system.  
> It’s not about debugging but **the first step in design.**

Now, let's move beyond solving problems to designing structures that prevent problems.

---

# Reference. Memory Management Examples in Different Languages and Environments

Memory management is not just about heap and stack issues.  
Depending on the language, platform, and runtime structure, memory management strategies are designed differently.

The following examples show how each environment controls memory and how it influences thinking.

- C++/Rust: Design resource release in structure with RAII and Ownership
- Java: Separate GC targets based on object lifespan (Eden → Tenured)
- Python: Reference counting + cycle detection
- Swift: Manage object lifespan with ARC, be cautious of cyclic references in closures
- Rust: Prevent compile-time errors with ownership and borrowing checker
- Node.js: Reference leaks in closures and event loops
- JVM on Cloud: Disable THP, configure heap, tune GC
- Serverless: Lambda memory settings and cold start strategies
- Game Dev: Maintain frames with object pooling
- Chrome: Restart after reaching process memory limit

---