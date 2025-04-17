---
date: 2025-04-16
permalink: /en/2025/04/16/robot-fleet-onpremise.html
tags:
- Platformization
- Business Connection
- Project
title: Designing a Robot Control System that Implements Cloud Development Experience
  On-Premises
---
> `gpt-4-turbo` has translated this article into English.

---

This is a case study of transitioning a robot control system designed for the cloud to an on-premise environment, while maintaining the same development flow and collaboration efficiency. The key was not moving the technology stack, but **transplanting the development experience itself into the design structure**.

---

## Problem Recognition

Certain environments with security requirements restrict the use of cloud infrastructure due to security policies. However, the original system was optimized for a **complete cloud environment** using Lambda-based event handling, Kafka/NATS brokers, and WebSocket UI, so a shift to on-premise was expected to disrupt the development flow and degrade the operational real-time capabilities.

---

## My Design Philosophy

I believe that the essence of design is not about transferring technology, but about **keeping the flow experienced by developers and operators the same**. Ultimately, messages should transcend environments, and platforms should be defined by **consistency of experience** rather than technology.

---

## Design Direction

From this perspective, instead of merely imitating the cloud architecture, I **restructured the development flow to suit the on-premise environment**.

- **Designing a switching messaging structure with Kafka and NATS**
- **Developing a WebSocket-ROS bridge** to directly connect UI and control systems
- **Implementing a FaaS environment with Kubeless** to maintain event-based MSA
- Integrating all components on top of the **ROS message flow**

---

## Results

The message flow used by operators and developers was maintained exactly as before, and a **cloud-level real-time control service** was commercialized even in an on-premise environment. Moreover, the structure was designed to be reusable, enabling validation of its applicability to other indoor robot services and multi-site deployments.

---

## In Conclusion

This case demonstrates how powerful it can be to design flows rather than replicate technology. The role of a designer, as I see it, is not to bring in new technology, but to make familiar flows work in new environments.