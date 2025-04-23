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

> The Truth About Structure and Performance Hidden Behind Code
> This article discusses the memory perspective necessary for transitioning from 'someone who writes code' to 'someone who designs systems'.

---

# 1. Why Should We Discuss Memory?

“Isn't memory something we don’t have to worry about these days?”

Many developers think this way.  
Indeed, most modern languages manage memory automatically, and in many cases, you can create programs without direct memory control.

However, this doesn’t mean that the concept of memory has disappeared, it just means that **we might not experience the difficulties of memory management**.

The actual problem lies in our attitude, which considers memory management as something ‘we don’t need to worry about’.

For instance, one day, a system crash occurs for no apparent reason.  
There’s nothing in the logs, and monitoring shows no abnormalities. Yet, memory usage is steadily increasing.  
At that moment, someone might say:

> “Shouldn’t the GC take care of it?”

Is that really the case? The Garbage Collector (GC) is not omnipotent.  
The timing and method of GC operation, conditions under which objects are not released, and references tied to root objects are all **problems that can only be solved with knowledge**.

And this is not just an issue for languages with GC like Java or Python.  
In C/C++, Rust, and even in embedded environments, **memory is always at the core of the structure**.

Developers ultimately are **the ones who create something** and **design how it works**.  
Being unaware of memory is like an architect not understanding how concrete sets.

This article discusses memory.  
But it’s not about organizing variables or sharing tips.  
We aim to explore **how thinking about memory can change our perspective** and **why understanding memory changes our viewpoint**.

When you understand memory, your code changes.  
And at that moment, **things that were not visible start to become visible**.

---

# 2. The Memory We Unwittingly Overlook

Every developer declares variables, creates objects, and calls functions.  
However, few can precisely recall the process each action triggers in memory.

Most development environments are very adept at hiding this process.  
Python manages reference counts, Java collects memory via GC, and JavaScript has its memory handled by the browser and runtime.  
So, we start to develop without a conscious awareness of memory.

However, when problems arise or when analyzing performance, we inevitably return to memory.  
Even when it's not visible, memory is always silently determining how programs operate.

- **Stack** is the space for function calls and local variables.  
  As calls are nested, stack frames accumulate and are released upon return.

- **Heap** is the space for dynamic allocations.  
  Objects created at the developer's request are stored here, and the timing of their release is sometimes unclear.

- **Garbage Collector (GC)** manages the heap area.  
  However, it's difficult to predict which objects will not be collected and remain.

- Just because a reference is cut, it does not mean memory is immediately freed.

## 2.1 Control Unit and Stored Program: Memory is the Starting Point of Execution

Memory is not just a container for data.  
The **instructions** we write, i.e., our code, are also stored in memory.

This is the essence of the 'stored-program architecture'.  
Computers store both instructions and data in the same memory space.  
The control unit retrieves instructions from this memory one line at a time to control the execution flow.

Thus, a program is essentially a **flow of instructions stored in memory**.  
**Understanding memory means fundamentally understanding how a program executes**.

Writing code without understanding memory is like designing an assembly line without seeing the flow of the conveyor belt.

Now we realize that memory is not just a simple space issue but is the starting point for **flow and control** and **structural thinking**.

---

# 3. The True Appearance of Code Revealed by Understanding Memory

The code appears to work fine.  
There are no errors, and it performs its functions correctly.  
However, as it operates over time or the number of users increases, the system slows down and may eventually crash.

The problem is not visible.  
Because the code looks logically perfect.  
However, beneath that, memory is slowly deteriorating.

## Example 1: Repeated Dynamic Allocation

```python
def append_items():
    result = []
    for _ in range(1000000):
        result.append("item")
    return result
```

- This code creates a new string object each time and adds it to the list.
- If the list is not freed after use, GC cannot collect it, and it remains in memory.
- It may seem unproblematic temporarily, but repetitive calls will gradually fill up the heap.

## Example 2: Reference Leaks in Event Handlers

```javascript
function setup() {
    const el = document.getElementById("btn");
    el.addEventListener("click", () => {
        // Unwittingly creating a closure that references the external context
        console.log("clicked");
    });
}
```

- Even if the event is removed, the handler closure often remains alive along with the DOM.
- GC cannot break this reference chain.
- Developers might wonder, "Why is the browser getting slower?"

```java
Map<String, Object> cache = new HashMap<>();
public void load(String key) {
    cache.put(key, new Data()); // Accumulates endlessly without overwriting
}
```

- Continuously adding data to a cache without a removal logic leads to endless memory increase.
- Objects piled up in the heap are not targeted by GC.
- This pattern is more dangerous because it appears to be ‘well-written code’ in practice.

These problems can **only be detected by someone who views memory ‘structurally’**.
It's not just a feeling of "something is slow," but a thought process like,
**"This object is not released → GC cannot collect it → It's connected to a root object."**

At that moment, a developer transitions from merely ‘implementing a function’ to
**‘designing the flow of resources’**.

We now understand.
The difference between what is visible and invisible, the boundary lies in memory.

---

# 4. A Shift in Thought: Centering Development Around Memory

So far, we have looked at issues like memory leaks, GC delays, and failure to release references.  
All these problems share a common trait: they are **‘code that works but is incorrect’**.

Now, we must change our question.

> From “Why is it wrong?”  
> To “Why should it be structured this way?”

Memory thinking is not just a technique for catching bugs.  
It's a framework that **changes the very perspective with which we design programs**.

Once you understand memory, questions naturally arise:

- When should this resource be created and released?
- Who should take responsibility for it?
- Can it be reused or should it be destroyed?
- How does unnecessary retention affect performance?

These questions **go beyond mere code writing**,  
**only considered by those who design structures**.

## 4.1 Memory is Not Just a Place to Store Data

We've looked at the concepts of control units and stored programs earlier.  
Understanding this structure helps us realize that memory is not just a space but **the core that supports the flow of a program**.

- The control unit fetches and interprets instructions from memory.  
- Instructions are stored with data in the same space.  
- This stored flow is the program, and the program is a structure designed around that flow.

This shift in thought transforms developers.

Beyond just naming variables well and organizing logic efficiently,  
we now ask questions like:

- **How does this system cycle resources?**  
- **Is this flow structurally designed?**

At that moment, developers transcend being mere implementers and become
**people who design structures**.

And it all starts with a subtle shift in awareness,
**relooking at memory**.

---

# 5. Conclusion: When You Understand Memory, Development Changes

Developers are ultimately in a position to **design structures**.  
How to implement a function, how to use resources in what flow —  
We consider all these decisions together.

Understanding memory means transcending the mere use of structures,
**shifting to designing and taking responsibility for that flow**.

The aim of this article is not to list memory tuning tips.  
It's to share a turning point where **the developer’s perspective changes**.

- Why does the system slow down?
- Why does GC sometimes not help?
- Why do similar functionalities in code show performance differences?

All answers lie **on memory**.  
Specifically, whether you understand memory or not.

When you understand memory,
we see not just code but **structures**,
not just bugs but **flows**.

At that moment, we move beyond
**‘working code’ to ‘designed programs’**.

And that starting point,
begins with this question.

**“Do you understand memory?”**

---

# Appendix. A Guide for Developers Who Understand Memory

This article proposes viewing memory not just as a simple resource but as a tool for thought.  
However, in practice, memory often appears as **a target for debugging**, **a bottleneck in performance**, **a complexity in design**.

This appendix organizes typical memory-related problems into **symptoms, principles, strategies, and tools** to expand the practical sense of understanding memory.

## 1. Memory Leak

**Symptoms**: Memory usage does not decrease over time but continues to increase, eventually slowing down or shutting down the system.  
**Principle**: Objects that are no longer in use are excluded from GC targets, or manually allocated memory is not freed, remaining in the heap.  
**Strategy**:  
- Check the local state of functions that are called repeatedly and break the reference relationship with root objects.  
- Analyze the causes of prolonged object lifespan.  
**Tools**: `Valgrind`, `AddressSanitizer`, `Memory Profiler`

## 2. Invalid Memory Access

**Symptoms**: NullPointerException, segmentation fault, array boundary overflows, and other exceptions  
**Principle**: Invalid pointers, references to freed objects, access beyond boundaries  
**Strategy**:  
- Thoroughly check pointer validity and learn reference safety patterns specific to languages.  
- Use automated static analysis tools to detect errors at coding time.  
**Tools**: `GDB`, `Valgrind`, `AddressSanitizer`

## 3. Memory Fragmentation

**Symptoms**: Failure of large allocations despite sufficient memory, increasing allocation/deallocation time  
**Principle**: Heap becomes fragmented due to frequently allocated and freed blocks of various sizes  
**Strategy**:  
- Apply `Memory Pool` or `Slab Allocator` structures that use memory blocks of the same size.  
- Cache or reuse frequently allocated objects.  
**Tools**: Slab Allocator, jemalloc, tcmalloc

## 4. Buffer Overflow

**Symptoms**: Sudden crashes, stack damage, unexpected behavior  
**Principle**: Occurs when data is written beyond the fixed array range  
**Strategy**:  
- Use safe functions (`strncpy`, `snprintf`) and add size checks to all array operations.  
- Enable overflow detection with compiler flags.  
**Tools**: `AddressSanitizer`, `Stack Smashing Protector (SSP)`

## 5. Garbage Collection Issues

**Symptoms**: Intermittent delays, pauses, memory collection failures  
**Principle**: Objects that are not disconnected from references remain in GC roots and are not collected  
**Strategy**:  
- Clearly distinguish object reference cycles and use `WeakReference` and similar tools.  
- Analyze GC logs to identify patterns of uncollected objects.  
**Tools**: `G1GC`, `VisualVM`, `Memory Analyzer`

## 6. Cache Pollution

**Symptoms**: Increase in cache misses, performance degradation, reduced data locality  
**Principle**: Frequently unused data enters the cache, pushing out frequently used data  
**Strategy**:  
- Redesign data access order to increase spatial and temporal locality.  
- Store Hot/Cold data separately and consider structure alignment.  
**Tools**: `Cachegrind`, `Intel VTune`

## 7. Data Race

**Symptoms**: Irregular behavior in a multi-threaded environment, variable values different from expectations  
**Principle**: Occurs when two or more threads try to write to the same memory without synchronization  
**Strategy**:  
- Protect shared resources with `Mutex`, `Lock`, `Atomic`, etc.  
- Document the scope and ownership of locks and detect race conditions in tests.  
**Tools**: `Helgrind`, `ThreadSanitizer`, `Concurrency Visualizer`

## Conclusion

This guide is designed not just as a list of tools but as a practical manual that follows the flow of **recognizing problems → understanding structures → implementing strategies**.

> Understanding memory ultimately means controlling the flow of the system.  
> It's not just about debugging but **the first step in design**.

Now, don't just stop at solving problems,
but move forward as a developer who designs structures that prevent problems from arising.

---

# Reference. Memory Management Examples Across Languages and Environments

Memory is not just a simple issue of heap and stack.  
Depending on the language, platform, and runtime structure, memory management strategies are designed differently.

The following examples show how different environments control memory and how they influence thinking.

- C++/Rust: Design resource release structurally with RAII and Ownership
- Java: Segregate GC targets based on object lifespan (Eden → Tenured)
- Python: Reference counting + cycle detection
- Swift: Manage object lifespan with ARC, and be cautious of cyclic references in closures
- Rust: Prevent compile-time errors with ownership and borrow checker
- Node.js: Reference leaks in closures and event loops
- JVM on Cloud: Disable THP, configure heap, tune GC
- Serverless: Lambda memory settings and cold start strategies
- Game Dev: Maintain frames with object pooling
- Chrome: Restart after process unit memory limit

These cases illustrate that memory management is intricately linked to the structural, platform, and runtime characteristics of the environments developers work in.