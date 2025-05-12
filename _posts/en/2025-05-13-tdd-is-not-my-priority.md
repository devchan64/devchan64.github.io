---
date: 2025-05-13
layout: post
permalink: /en/2025/05/13/tdd-is-not-my-priority.html
tags:
- Design Philosophy
title: '"I Don''t Consider TDD Important"'
---

> `gpt-4-turbo` has translated this article into English.

---

I no longer say "Let's do TDD."  
Instead, I say:

> "TDD is good, just start with the minimum initially."  
> "But first, let's design the flow and points of observation."

When creating a product,  
it's impossible to predict all usability and flows from the start.  
Unexpected situations keep occurring,  
and each time, we rely on the structure.

Thus, I think about the **structure of flow** rather than testing,  
and **observable systems** rather than predictions.

This article is an attempt to explain why I find **observability and traceable structures** more important than TDD, following the technical flow I've experienced.

The flow can be summarized as follows:

> **EDA → MSA → Metrics → O11y (_Observability_)**

Within this, I have focused on designing flows through  
**distributed computing**,  
**data-centric design**,  
**messaging architecture**,  
**Gateway and Bridge**.

---

## The Thought Process I've Walked Through: EDA → MSA → Metrics → O11y

Looking back, I've always been more concerned about how to create flows and how they can be observed rather than designing tests first.

This naturally led to the following thought process:

### EDA (Event-Driven Architecture)

I believed calculations should only occur when absolutely necessary.  
Not just to save resources, but more importantly, to clearly define the ‘conditions’ under which the system should react.

That condition was the ‘**event**’.  
When a change is detected,  
a system designed to react to that change  
**reduces unnecessary computations and clearly divides flow units.**

An event-based structure  
became the starting point for dividing the system into observable units.

### MSA (Microservices Architecture)

Initially, within a single system, I focused on **abstracting and modularizing responsibilities and flows**.  
As functions were finely divided and boundaries were clearly distinguished,  
each function began to possess a structure that could **exist independently**.

This naturally led to the distribution of dependencies and flows,  
preparing each module to be separated into **different services**.

**Abstraction → Modularization → Distributed structuring**  
Following this flow,  
I eventually found myself utilizing the MSA structure.

MSA was not the goal but a  
natural result of efforts to divide the structure well.

### Metrics (Data-Driven Development)

Once flows are divided and designed into a distributed structure,  
it's necessary to verify how these flows actually occur.  
The question "**What happened?**" needs to be addressed not just through logs or console outputs but as **Metrics**.

Thus, I began to **define events for each flow**,  
recording the times and outcomes of these events.  
This accumulated data became **metrics**,  
and metrics soon became the **criteria for interpreting and judging the system**.

Increasingly,  
**understanding the system through data rather than code** became natural.

### O11y (Observability)

While defining flows, events, and metrics,  
I eventually came to one critical question:

> **"What's happening inside this system right now?"**

This question wasn't just about logging or analyzing errors later.  
From the moment of designing the system's flow,  
it meant that points of observation must also be designed.

Events and metrics alone weren't enough.  
They needed to be structured in an interpretable form so  
we could understand the system's state 'from the outside'.

Thus, when designing structures,  
I approached by **including observation points as design elements**.  
This naturally led to a development approach where, before TDD,  
flows were designed and defined in an observable manner.

---

## ODD Was Familiar to My Development Approach

When I first encountered the concept of ODD (_Observability-Driven Development_),  
it didn't feel unfamiliar or new.  
Instead, it naturally felt like:

> **"The way I've been developing was similar to this."**

I did not start from an **SRE perspective**.  
Instead of operational efficiency or incident response,  
I focused on how to design the system's flow and make it interpretable in data units.

The questions I've always pondered were similar:

- In a distributed computing environment, how can resources be used efficiently?
- How can event-based asynchronous structures be made into traceable units?
- How can the system's operations be interpreted through data?

Within these questions,  
I naturally divided flows, defined boundaries, and  
built data on top of them.

The resulting structure was ultimately a system  
centered around **observability**.

ODD provided a refined language to describe the thought process I had been cultivating,  
and its philosophy naturally aligned with the direction I had long contemplated.

---

## Messaging Is the Language of Flow

To create a traceable structure of flows,  
**messaging** (_Messaging_) has been my primary technical focus.

Initially, I approached it merely as a communication technique for asynchronous processing.  
However, once I viewed the system as message-centric,  
I realized that flow is messaging, and messaging defines the system's structure.

The power of messaging lies in its simplicity.  
Beyond merely transferring data,  
it defines **how the system reacts and changes in units**.

- Messages clearly define units of flow.
- They separate time and space,
- reduce coupling between services, and
- record when and what events occurred.

Messages are more than just a means of communication.  
They are **units of design and clues for tracing and interpreting**.

Thus, I design messages before the code.  
The question "**How should the flow be designed?**" must first be answered by messaging.

---

## Gateways and Bridges Are the Entry Points of Flow

To observe flow,  
it's essential to identify where the flow passes through.  
I have designed these points through structures known as **Gateways** and **Bridges**.

These are not just communication paths but entry points that enable recording and interpreting flows.

### Gateway: The Entry and Termination Points of Flow

A Gateway is where the external and internal systems meet.  
All moments of requests coming in, responses going out, and occurrences of errors and delays  
are recorded as they pass through the Gateway.

I design this structure not just as a simple API routing layer but as a  
**starting point for observation and measurement**.

- It collects Metrics per request,
- tracks transactions,
- and defines the structural boundaries between external and internal elements.

### Bridge: The Transition Point for Reinterpreting Flow

A Bridge connects flows with different interpretation systems.  
It's not just about transmitting messages but about  
**a structural transition where responsibilities and meanings are redefined**.

Bridges perform the following roles:

- Transform message formats,
- transfer responsibilities between domains, and
- maintain loose connections between systems.

I design Gateways and Bridges as  
clear structural interfaces that allow for the observability of flows and  
enable the system to operate on interpretable boundaries.

---

## Start with Design-First and Divide When Necessary

I don't target MSA from the start.  
**It's not about the technology stack,  
but how the flow and boundaries are designed that is crucial**.

Thus, I always start with **Design-First**,  
meaning **designing the structure of the flow first**.

> "Design the flow first,  
> equip it with an observable structure,  
> and divide it when necessary."

Initially, I execute quickly within a monolithic structure.  
However, I always prepare the following within it:

- Design a messaging structure for each flow,
- separate responsibilities between domains, and
- clearly define points for collecting Metrics.

This prepared structure may look like one solid block initially,  
but it can evolve into a system that is **always decomposable and traceable**.

To me, MSA is not a declaration but a structural result naturally reached once boundaries become clear.

---

## Efficiency, Flow, and Traceability Are Central to My Thinking

When designing systems, the most crucial criteria I consider are threefold:

> **Efficiency**, **Flow**, and **Traceability**

### Efficiency: Is This Operation Necessary Now?

Computing resources are always finite.  
So, from the design stage, I always ask:

> "Is this operation necessary right now?"  
> "Can this structure flow without wasting resources?"

This question naturally led to designing **event-based, asynchronous flows**.

### Flow: Unplanned Flows Are Unstable

An efficient system is a system that follows a **designed flow**.  
Requests and responses, triggers and processing, transmission and storage must  
flow in an **intended sequence and in a predictable manner** for the system to be stable.

### Traceability: Flows Must Be Observable

No matter how well a flow is designed, if we can't confirm it actually works as intended,  
the system cannot be interpreted or maintained.

Thus, I define flows centered around messages,  
design the gateways of flow through Gateways and Bridges, and  
consider observable structures as part of the design.

The traceability I emphasize is not just about monitoring in operations but about preparing for the interpretability of the system from the design stage.

In that sense, I felt ODD was very similar to my philosophy.

---

## Conclusion: The Key Is Flow and Structure

TDD is an excellent development technique.  
However, the question that always comes to mind first for me has been:

> **"What's happening inside this system right now?"**

Being able to answer this question means that  
we can say we have designed the system.

To find that answer,  
I first divide the flow, design the structure around messages,  
and define observation points through Gateways and Bridges.

At the core have always been  
an understanding of distributed computing environments,  
a data-centric interpretation method,  
and a structure design centered on observability.

ODD was a later discovery but a concept that  
**clearly explains many of the things I've contemplated as a designer**.

---

This philosophy isn't just theoretical, as I've clearly seen through my experience with **ROS** (_Robot Operating System_).

ROS is a system that implements a message-based distributed computing structure stably over TCP.  
Even though sensors, actuators, and control nodes were loosely connected through messages,  
the flow was clear, and the system functioned organically.

In it, I first felt that the structure "works."

This experience confirmed:

- That messages could define flows,
- That components could be separated into independent, traceable units, and
- That observability and distributed efficiency could be implemented together.

And most importantly,  
**designing messages first**,  
and then methodically building **flow and structure on top of that**,  
is not just a philosophy but a thoroughly feasible design approach.