---
date: 2025-04-08
layout: post
permalink: /en/2025/04/08/message-oriented-design-definition.html
tags:
- Design Philosophy
title: '"Defining Design with a Focus on the Message"'
---
> `gpt-4-turbo` has translated this article into English.

--

Today, most devices are connected to the network.

Beyond simply exchanging data, each device processes messages in real-time, interacts with users, and exists within the system as an 'actor'.

This change is also significantly impacting the way systems are structured.

In the past, structures primarily consisted of connecting functional units through calls, but now many devices require an **asynchronous and loosely connected structure**, with a design approach increasingly centered around messages.

I am focusing on the concept of **'messages'** in this flow of change.

A message is not just a unit of transmission; it is a crucial design element that defines interactions between systems and shapes their flow.

This article aims to explain what it means to center system design around messages and how such a perspective can make a difference in actual design.

# The Era Where Every Device Becomes a Browser

Lately, digital devices have been transforming from mere command receivers and data collectors into **participants in the network that react and exchange messages in real-time**.

Sensors, controllers, household appliances, and industrial equipment are

no longer just objects that perform actions. They express their own status, communicate with the outside, and are becoming **significant nodes** that impact the entire system.

At the heart of this change is the trend of 'browsing'.

A browser is no longer just the endpoint of a user interface. Through technologies like WebSocket, MQTT over WebSocket, and SSE, it has expanded into a **client platform that can directly participate in real-time message flows**.

Now, many devices operate like browsers.

They subscribe to messages on their own, publish based on conditions, receive data to display, or update their status.

This means that **all devices are becoming members of the real-time message network**.

The number of devices continues to increase, and clients in various forms like web, mobile, embedded, and edge devices are connected and moving simultaneously.

In such an environment, it is difficult for the system to maintain a fixed structure that operates in a predefined flow.

Instead, a flexible flow centered around messages and a loose connection between distributed participants are needed.

This article will unravel what it means to **look at and design systems centered around messages** within this era.

---

# Systems are Structurally Distributed

Modern systems do not operate within a single consistent environment.

Clients have diversified into mobile, web, and edge devices, and servers are distributed as computing resources in the cloud, on-premises, and as microservices.

Even within the same system, it is common for disparate components using different technologies, languages, and infrastructure environments to coexist.

In this **physical and logical distributed environment**, situations like time delays, connection instability, and processing failures must be **accepted as the norm rather than exceptions**.

In other words, systems cannot always be connected, requests may not be processed immediately, and responses may arrive at unpredictable times or not at all.

In this environment, the fixed request-response structure reaches its limits.

The system can no longer consist only of sequential call relationships; instead, **each component must be loosely connected through messages and operate independently of time**.

Here, a message is not just a means of communication.

It is the unit of delivery for intentions, states, and events, and the **design link that enables interaction between distributed elements**.

And the infrastructure that allows messages to flow smoothly, and when necessary, collects, controls, and distributes these messages, is precisely the message broker.

Ultimately, a message broker is not just simple middleware but must become a **core structure that maintains and coordinates the flow of a distributed system**.

---

# Things Change When You First Look at Messages

The traditional approach to system design focuses on functionality, defining the structure first and then designing communication to fit that flow.

However, when you first look at messages, the system begins to appear in a completely different light.

### 1. Flow is visible first, and structure follows

When messages are at the center, you first see **what messages the system needs to exchange to function**.

Functions are organized as units to implement that message flow.

In other words, the structure is not a fixed framework but a **result built on the flow of messages**.

This clarity enhances the overall context of the system, and the roles and boundaries of each function become clear.

### 2. Coupling decreases, and experimentation becomes easier

If components are divided by message units, the direct call relationships between functions disappear, and **loose connections through publishing and subscribing** become possible.

This structure allows new functions to be added or removed without impacting existing code, providing a **foundation for safely conducting small-scale experiments and disposals**.

This is precisely why a design centered around messages leads to **disposable code**.

By separating the flow based on messages, specific functions can be independently managed from creation to removal.

---

### 3. Operations and scaling become more flexible

Since all message flows are structurally visible, it becomes easier to track events or observe states.

It is also possible to respond at the flow level or control individual messages during operations.

Additionally, simply connecting new subscribers to the message broker allows for expansion without changing the existing system.

This shows that a message-centered design provides flexibility in both operations and scaling.

---

### 4. Designing messages means defining the conversation of the system

I understand messages not just as a data format but as a **way of conversation between systems**.

Conversations differ from calls.

They must be understandable even if the order is not guaranteed, and sometimes they must be remembered or ignored.

Messages provide a structure that can accommodate these **imperfect and flexible interactions**.

Therefore, when configuring a system, I design **what messages need to be exchanged** before considering what to call.

# The Broker Must Become the Center of Flow

When viewing the system with messages at the center, the broker appears not just as a transmission device but as a **core structure that orchestrates and separates the flow**.

The broker connects the interactions within the system through a single channel while keeping each component **independently maintained**.

---

### 1. Separates connections and integrates flow

The broker does not directly connect the sender and receiver.

By relaying messages between them, it creates a structure that allows each component to operate without knowing each other.

This structure increases the system's flexibility and simplifies the process of adding new functions or replacing existing ones.

---

### 2. Collects and controls the flow

The fact that all messages pass through the broker means that every movement of the system is **observable as a single flow unit**.

This creates control points such as:

- Message filtering and routing
- Event logging and tracking
- Applying QoS and controlling flow
- Temporary blocking, priority handling, etc.

The broker is not just a communication path but an **operational point that can observe and control the system's conversational flow**.

---

### 3. Leads design to be message-centered

With the broker at the center, the system is structured around flow, not functionality.

This makes the overall structure simpler and more flexible, allowing functions to be interpreted in units of messages.

While call-based interfaces form vertical layers, broker-based messaging enables **horizontal interactions**.

This, in turn, makes the system's entire relational structure clearer and looser.

---

### 4. Accommodates the possibility of change

Systems are always changing.

Adding new functions, conducting temporary experiments, or removing existing functions are naturally recurring events.

The broker is a structural buffer that prepares for these changes.

When adding a new flow, it does not affect existing code, and failed or terminated functions can be removed by simply cleaning up the message flow.

This characteristic is why a system structured around messages can **naturally accommodate changes and experiments**.

# EMQX is a Space Filled with Possibilities for Experimentation

So far, I have discussed why we look at systems through the lens of messages and the structural advantages of doing so.

To actually realize this structure, a broker that can accommodate and relay the flow is necessary.

At this point, I am focusing on **EMQX**, an MQTT-based broker.

EMQX aims to be more than just an MQTT broker, providing a **flexible experimental space that can realize message-centered design in a distributed environment**.

---

### 1. It is web-friendly

EMQX supports not only MQTT but also MQTT over WebSocket by default.

This allows **browser-based clients to directly participate in the real-time message network**.

It provides an environment where the web and IoT devices can communicate organically within the same message flow.

---

### 2. It is portable and scalable

Thanks to its lightweight cluster structure, support for various client libraries, and a deployable architecture in both cloud and edge environments, **EMQX can be applied without platform constraints**.

Whether the operational environment is small or large, it can flexibly respond from experimentation to commercial use.

---

### 3. It can handle message flow through policies

EMQX offers various **policy-based settings, filtering, and authentication control functions** for message flow.

This allows the message broker to be used not just as a relay but as an **operational environment that contains design and operational rules**.

A space where messages are defined, their flow designed, and their operation controlled.

EMQX itself becomes a **design laboratory and observation point**.

---

### 4. It creates a structure that allows for experimentation and disposal

The cycle of attaching new flows, configuring temporary subscribers, and removing successful or failed functions can be performed **without complex restructuring** on EMQX.

This provides the foundation for realizing the core philosophy of message-centered design: **"disposable code" and "flexible structure"**.

# EMQX is Not the Only Option

While I am implementing message-centered design through EMQX, the purpose of this article is not to recommend a specific tool or claim that EMQX is the only solution.

What's important is the perspective of **starting with messages as the structural starting point**, and EMQX is just one of the potent means to realize that perspective.

---

### Technology Continues to Change

Better tools or methods may emerge in the future.

The possibility of new messaging protocols based on WebTransport or QUIC, or even a new model where the browser itself acts as a broker, also exists.

Such changes are a natural flow, and what's important is having a structure and perspective that can **flexibly adapt to these changes**.

---

### I Look at Structure First and Choose Tools Accordingly

Technology is a means.

As long as any tool can realize the structural goal, there are options.

I chose EMQX because its structure best matched the flow and philosophy I wanted to design at the moment.

However, other tools may be more appropriate in different environments and conditions.

Ultimately, what matters is not the name of the tool, but **what structure it can enable**.

---

### A Flexible Attitude Preserves Structural Thinking

Focusing too much on tools makes you vulnerable to technological changes.

On the other hand, focusing on structure ensures that the direction of the design remains even if the tools change.

As a designer and developer, I always aim to maintain an attitude that looks at structure before tools.

While this article discusses EMQX, underlying it is the **designer's thought and standard that seeks to define and design flows centered around messages**.

---

# Conclusion: Designing Messages

Designing a system is about defining flows.

Flow is not just the sequence of functions; it is the **overall interaction where intentions are conveyed, responses occur, and states change**.

I place messages at the center of this flow.

Messages are more flexible than calls and closer to meaning than states.

Messages provide a unit that can **loosely connect the components of a system while structurally coordinating them**.

---

### Designing messages means defining the structure

Before designing functions, I define **what messages the system must exchange**.

In this process, the boundaries, roles, and directionalities of the flow between participants naturally emerge.

Ultimately, designing messages means **deciding first how the system should move and communicate**.

Structure follows, and tools become the means to realize that structure.

---

### Messages are the language of the system

The system must communicate with both the outside and inside.

That language of communication is messages.

I believe this language should be clear, observable, and deletable.

Such a message-based structure creates a flexible system that can accommodate experimentation and change, expansion and reduction, failure and recovery.

---

# In Closing

This article is not intended to introduce EMQX.

I wanted to share the perspective of looking at systems centered around messages.

And I chose EMQX as one experimental space to realize that perspective.

As systems become more complex, the structure must be simple and robust.

If the smallest unit of that structure is messages, then I will design those messages first.