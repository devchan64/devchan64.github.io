---
date: 2025-04-08
layout: post
permalink: /en/2025/04/08/message-oriented-design-definition.html
tags:
- Design Philosophy
title: '"Defining Design with a Focus on the Message"'
---

> `gpt-4-turbo` has translated this article into English.

---

# Defining Design with a Focus on the Message

---

# The Era of Every Device Becoming a Browser

Recently, digital devices have evolved from mere command receivers and data collectors to active participants in the network, **reacting in real-time and exchanging messages**.

Sensors, controllers, household appliances, and industrial equipment are no longer just operational entities; they express their status, communicate externally, and become **meaningful nodes** influencing the entire system.

At the heart of this transformation is the trend of 'browserization.'

The browser is no longer just a user interface endpoint but is expanding into a **client platform capable of directly participating in real-time message flows** through technologies like WebSocket, MQTT over WebSocket, and SSE.

Now, many devices operate like browsers.

They subscribe to messages autonomously, publish based on conditions, receive data to display or update statuses.

This signifies that **all devices are becoming part of a real-time message network**.

The number of devices continues to grow, and clients in various forms like web, mobile, embedded, and edge devices are connected and active simultaneously.

In such an environment, the system can no longer be sustained with a rigid structure that operates in a predefined flow.

Instead, a flexible flow centered on messages and loose connections between distributed participants is becoming necessary.

This article aims to unfold, within this era, **what it means to re-envision and design systems centered around messages**.

---

# Systems are Structurally Distributed

Modern systems do not operate within a single consistent environment.

Clients vary from mobiles and web to edge devices, and servers are also distributed as cloud, on-premises, and microservice-based computing resources.

It is common for different technologies, languages, and infrastructural environments to coexist within the same system.

In such **physical and logical distributed environments**, conditions like latency, unstable connections, and processing failures must be **accepted as the norm rather than exceptions**.

This means systems can't always be connected, requests might not be immediately processed, and responses could arrive unpredictably or not at all.

In such environments, a fixed request-response structure hits its limits.

Systems should no longer be structured solely around sequential calls; instead, **each component needs to be loosely connected via messages and operate independently of time**.

Here, a message isn't just a means of communication.

A message is a unit of intent, status, and event transmission, and a **design link enabling interactions between distributed elements**.

And the infrastructure that allows messages to flow smoothly, and when necessary, to be collected, controlled, and distributed, is precisely the message broker.

Ultimately, a message broker should not just be simple middleware but a **core structure that maintains and coordinates the flow of a distributed system**.

---

# Changes Seen from a Message-First Perspective

The traditional way of looking at systems is function-centric, defining the structure first and then designing communication to fit that flow.

However, when looking at it from a message-first perspective, the system begins to appear quite differently.

### 1. The flow is visible first, and the structure follows

With messages at the center, what becomes apparent first is **how the system should operate and communicate**.

Functions are then organized as units to implement that message flow.

Thus, the structure isn't a fixed framework but a **result built upon the flow of messages**.

This clarity enhances the overall context of the system and sharpens the roles and boundaries of each function.

### 2. Coupling is reduced, and experimentation becomes easier

When components are differentiated by message units, direct call relationships between functions disappear, allowing for **loose connections through publishing and subscribing**.

This structure facilitates adding new functions or removing existing ones without impacting the rest of the code, providing a foundation for **safely conducting small-scale experiments and disposals**.

This is why a message-centric design leads to code that's ready to be retired.

By segregating flow based on messages, specific functions can be managed independently from creation to removal.

---

### 3. Operations and scaling become more flexible

Because all message flows are structurally visible, it becomes easier to track events or observe statuses.

During operations, it's possible to respond based on the flow or control individual messages.

Moreover, simply by connecting new subscribers to the message broker, expansion is possible without altering the existing system.

This shows that a message-centric design provides flexibility in both operations and scalability.

---

### 4. Designing messages means defining the system's dialogue

I see messages not just as data formats but as a **method of dialogue between systems**.

Dialogue differs from calls.

It must be understandable even if not sequenced, and sometimes it may need to be remembered or ignored.

Messages provide a structure that can accommodate such **imperfect and flexible interactions**.

That's why, when configuring systems, I focus on **what messages need to be exchanged** rather than what needs to be called.

---

# Brokers Should Be at the Center of Flow

When viewing a system from a message-centric perspective, a broker is seen not just as a transmission device but as a **core structure that orchestrates and separates flow**.

Brokers maintain independence among system components while linking their interactions through a single conduit.

---

### 1. Disconnect connections and integrate flows

Brokers do not directly connect senders and receivers.

By mediating messages between them, **a structure is created where components can operate without knowing each other**.

This structure enhances the system's flexibility and simplifies the process of adding new functions or replacing existing ones.

---

### 2. Collect and control the flow

That all messages pass through the broker means every movement in the system is **observable within a single flow unit**.

This allows for the creation of control points like:

- Message filtering and routing
- Event logging and tracing
- Applying QoS and controlling flow
- Temporary blocking, priority handling, etc.

The broker is not just a communication path but an **operational point where the system's dialogue flow can be observed and controlled**.

---

### 3. Leads design to be message-centric

With the broker at the center, the system is structured around flow rather than function.

This simplifies the overall architecture and allows functions to be interpreted through the unit of messages.

While interface-based calls form a vertical hierarchy, broker-based messaging enables **horizontal interactions**.

This clearly and loosely defines the relational structure of the entire system.

---

### 4. Structures that accommodate changeability

Systems are always changing.

Adding new functions, conducting temporary experiments, or removing existing features are naturally recurring events.

Brokers provide a structural buffer for these changes.

New flows can be added without impacting existing code, and failed or terminated functions can be removed just by cleaning up the message flow.

This characteristic is why systems structured around messages naturally accommodate changes and experiments.

# EMQX is an Experimental Space Full of Possibilities

So far, I've discussed why we look at systems from a message-centric perspective and the structural advantages it brings.

To actually implement such a structure, a broker capable of accommodating and relaying the flow is necessary.

Here, I focus on **EMQX**, an MQTT-based broker.

EMQX aims to be more than just an MQTT broker, providing a **flexible experimental space where message-centric design can be realized in a distributed environment**.

---

### 1. Web-friendly

EMQX supports not only MQTT but also MQTT over WebSocket by default.

This allows **browser-based clients to participate directly in the real-time message network**.

It provides an environment where web and IoT devices can communicate organically within the same message flow.

---

### 2. Portable and scalable

Thanks to its lightweight cluster structure, support for various client libraries, and deployability in both cloud and edge environments, **EMQX can be applied without platform constraints**.

It can flexibly respond to processes ranging from experiments to commercial use, regardless of the size of the operational environment.

---

### 3. Manage message flows with policies

EMQX offers various **policy-based settings and filtering, authentication control functions** for message flows.

This allows the message broker to be used not just as a simple relay but as an **operational environment containing the rules of design and operation**.

Defining messages, designing their flow, and operating through that flow creates a space.

EMQX itself becomes a **design laboratory and observation point**.

---

### 4. Creates a structure that allows for experimentation and disposal

The cycle of attaching new flows, configuring temporary subscribers, and removing successful or failed functions can be performed on EMQX **without complex reconfiguration**.

This is the foundation that enables the core philosophy of message-centric design: **"Expiry-Ready code" and "flexible structure"**.

# EMQX is Not the Only Option

While I am implementing message-centric design through EMQX, the goal of this article is not to recommend a specific tool or claim that EMQX is the only solution.

What's important is the perspective of **starting with messages as the structural starting point**, and EMQX is just one of the viable means to achieve this perspective.

---

### Technology Continues to Change

Better tools or methods may emerge in the future.

The possibility of new messaging protocols based on WebTransport, QUIC, or even browsers acting as brokers themselves also exists.

Such changes are a natural progression, and what's important is having a structure and perspective that can **flexibly adapt to these changes**.

---

### I See the Structure First and Choose the Tool Accordingly

Technology is a means.

If any tool can realize the structural goal, then the choice remains open.

I chose EMQX because its structure best matched the flow and philosophy I wanted to design at the time.

However, different tools may be more suitable in other environments and conditions.

Ultimately, what matters is not the name of the tool but **what structure it can enable**.

---

### A Flexible Attitude Protects Structural Thinking

Being fixated on tools makes you vulnerable to technological changes.

On the other hand, focusing on structure ensures that even if tools change, the direction of the design remains.

As a designer and developer, I always aim to maintain an attitude that looks at structure before tools.

While this article discusses EMQX, underlying it is a designer's thinking and standards aimed at defining and managing flows centered around messages.

# Conclusion: Designing Messages

Designing a system means defining its flow.

Flow is not just a sequence of functions but a **comprehensive interaction where intent is conveyed, responses occur, and statuses change**.

I place messages at the center of this flow.

Messages are more flexible than calls and closer to meaning than status.

Messages allow system components to be **loosely connected while structurally coordinated**.

---

### Designing messages means defining the structure

Before designing functions, it's essential to define **what messages the system should exchange**.

This naturally reveals the boundaries, roles, and directionalities of participants.

Ultimately, designing messages means **deciding first how the system should move and communicate**.

Structure follows, and tools become the means to realize that structure.

---

### Messages are the language of the system

The system must communicate both internally and externally.

That language of communication is messages.

I believe this language should be clear, observable, and ready to be retired.

Such a message-based structure accommodates experiments, changes, expansion, reduction, failures, and recoveries, creating a flexible system.

---

# In Conclusion

This article is not meant to introduce EMQX.

I wanted to share a perspective of looking at systems centered around messages.

And I chose EMQX as one experimental space to realize that perspective.

As systems become complex, the structure must remain simple and robust.

If the smallest unit composing that structure is a message, then I will design that message first.