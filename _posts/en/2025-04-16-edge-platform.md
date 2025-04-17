---
date: 2025-04-16
permalink: /en/2025/04/16/edge-platform.html
tags:
- Platformization
- Business Connection
- Technical Debt
- Project
title: 'Case Study: Revamping the Edge + Cloud Platform Architecture to Secure a Technological
  Foundation and Enable Scalable Replication'
---
> `gpt-4-turbo` has translated this article into English.

---
**Redesigning an Initially Implemented System into a Scalable Architecture and Verifying the Feasibility for Platform Reusability**

---

## Problem Recognition

Various edge devices such as access control units and temperature controllers were operating independently, with an imperfect connection structure to the cloud. Although functional, there was a lack of scalability, maintainability, and consistency in the developer experience.

---

## My Design Philosophy

I believe that the essence of a platform is not "device connection" but **"consistently organizing the flow and operational experience between devices."** I prioritize design focused on structure and flow, rather than technology and features.

---

## Design Direction

In this project, the goal was not just "implementing functions" but **designing it to be a platform**.

- **Structured MQTT-based messaging pipeline**
- **Introduction of AWS IoT Rule, Device Shadow, Greengrass** → Separation of state management and event handling
- **Docker-based edge operating environment** → Ensuring a consistent deployment environment
- **Schema-based message structure definition** → Ensuring compatibility and scalability between devices
- **Elimination and refactoring of existing technical debt (hardcoding, inconsistent logic)**

---

## Results

- Organized the flow between cloud and edge,
- Structured communication among various devices in a uniform manner,
- Transitioned to a **reusable structure for new device introductions**.
- Most importantly, secured a **platform basis that can be repetitively applied to multiple spaces with a single design**.

---

## In Conclusion

What I wanted to emphasize through this project was not just **'cleaning up code' but 'creating a structure that can expand business'**. While creating features is important, **designing a foundation that can be expanded** is what I believe to be the role of an architect.