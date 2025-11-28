---
date: 2024-11-01
layout: post
permalink: /en/2024/11/01/message-architecture-and-operational-design.html
tags:
- Project
- DevOps
- Platformization
title: 'Message-Based Architecture and Operations-Centric Design'
---
> `gpt-4-turbo` has translated this article into English.

---

# Message-Based Architecture and Operations-Centric Design

## 1. Problem Situation and the Crossroads of Choice

In an End-to-End service structure, devices, apps, authentication systems, and data platforms need to be organically connected. 
However, as connectivity increases, resilience to failures and maintainability decrease, and sensitivity to functional changes sharply increases.

Initially, the system was configured using a REST-based API calling method, but the following problems continuously occurred:

- Chain impacts on the entire service during failures
- Difficulties in service addition and change due to a near-monolithic structure
- Limited access for operators to trace or recover from problems

To overcome these structural limits, it was deemed more appropriate in the long term to transition to a message-centered asynchronous architecture rather than maintaining the existing structure.

## 2. Background for Choosing a Message-Based Design

A message-based structure means that each service is not directly called but is indirectly connected and operates independently through messages.

The reasons for choosing this structure are as follows:

- **Integrity is more important than real-time performance for business characteristics**
- **Isolation of failures through loose coupling between components**
- **Improved traceability for operators**

Especially, the message-centered structure has facilitated integration with visualization tools such as APM and Grafana, significantly helping improve real-time monitoring and response speed to problems.

## 3. Design Strategy and Acceptance Process Within the Team

This design was derived based on personal operational experience and previous technical backgrounds.
Particularly, past familiarity with the message-based architecture in the Robot Operating System (ROS) environment was very helpful.
ROS is fundamentally organized around a `Publisher`-`Subscriber` message communication structure, emphasizing distributed interaction and resilience among various components.

This technical foundation was critical not only as a simple implementation experience but also in forming a DevOps perspective that considers both operations and development in real field scenarios.
In this project, operational feasibility and response efficiency were set as core indicators from the early stages of design.

It was challenging to gain immediate empathy within the organization from the start.
Especially for developers and operators unfamiliar with message-based structures, it was difficult to accept structurally or felt complex compared to the existing REST-based architecture.

Therefore, the core advantages of the design were explained based on practical operational scenarios:

- **Cost Reduction**: Utilized managed services like AWS Kinesis to reduce infrastructure operational costs and manpower burden.
- **Ease of Problem Tracing**: Enhanced operators' problem analysis speed with trace ID-based log search and message list provision.
- **Secured Scalability**: Message queue-based structure enabled horizontal scaling at the consumer level, effectively responding to service increases.

Based on these advantages, specific cases were presented comparing it with the existing REST-centric structure, and the effectiveness and benefits of the message-based architecture were repeatedly explained to build consensus within the team.

> This design was an attempt that transcends mere messaging pathways, aiming for operational resilience, flexible scalability in design, and business-flow-centered structuring.
> 

## 4. Namespace-Based Hierarchical Structure and Design Philosophy

> ※ Note: The `data_service` area is not defined in this structure. 
> This was a strategic choice considering future integration possibilities into `data_platform`, as the role and responsibility of that layer were not clear at the time of design.

- `3rd_party.`: External system integration area
- `device.`: User access and device control interface
- `service_platform.`: Authentication, gateway, messaging, and business logic-centered layer
- `data_core.`: Data handling layer responsible for log collection, storage, ETL, and analysis

This namespace-based separation goes beyond simple directory distinctions, also serving as a method for tagging or grouping functions.
It was genuinely helpful in tracking the functional layer structure and clearly understanding the system's flow.
However, more important than the structure itself was whether **these namespaces were defined and agreed upon as a common language within the team**.
Consistency in linguistic alignment and clear meaning significantly enhances the intuitive interpretation of relationships between system components, fundamentally improving communication efficiency between developers and operators.

## 5. Architecture Diagram

The diagram below visually represents the hierarchical composition and message flow of the entire system.
It structurally explains how user requests and external events are introduced and processed.

```d2
direction: right
device.hw -- service_platform.auth -- service_platform.core
device.app -- service_platform.auth -- service_platform.api_gateway

3rd_party.app -- 3rd_party.cloud
3rd_party.hw -- 3rd_party.cloud
3rd_party.cloud -- service_platform.bridge -- service_platform.core

service_platform.core.messaging -- service_platform.core.event_rule
service_platform.core.event_rule -- service_platform.container

service_platform.api_gateway -- service_platform.container
service_platform.api_gateway -- data_core.data_api

service_platform.container.worker1 -- data_core.data_api
service_platform.container.worker2 -- data_core.data_api

data_core.data_api -- data_core.datalake
data_core.data_api -- data_core.etl_service
data_core.etl_service -- data_core.data_warehouse
```

## 6. Key Components of the Design

> Note: Initially, the introduction of Kafka was considered, but we chose AWS Kinesis-based managed services considering infrastructure management efficiency and manpower costs.
> 

### Message Handling Flow

- Asynchronous event flow configured through MQTT and Amazon Kinesis
- Each service is connected in a message subscription manner to block fault propagation

### Domain-Based Layer Separation

- Roles such as authentication, gateway, and messaging are distinguished and managed within `service_platform`
- Product domains are arranged in container units after the API Gateway, securing a structure that is easy to delete and replace

### Data Flow and Post-Processing Structure

- `data_core` configures a flow connecting data collection → ETL → statistics/analysis
- Future expansion plans to integrate `data_service` into a `data_platform` form

## 7. Operational Performance and Effects

- **Secured Observability**: Integration with APM, trace ID, Grafana, etc., enabled real-time monitoring, allowing quick cause tracing at the flow level when problems occurred. Previously, it took hours to analyze the cause of a failure, but with the introduction of a message-based structure, major flows and responses became possible within minutes.
- **Improved Resilience**: Pre-designed automatic reprocessing and recovery flows allowed localized problem handling without affecting the entire service.
- **Maintenance Convenience**: Enhanced operator accessibility through message tracing, logging, and message list management, forming a structure where operators and developers could discuss problems on the same standards.
- **Established a DevOps Collaboration Foundation**: The message-based structure allowed operators and developers to understand and discuss the system based on the same message flow and structure, positively influencing the establishment of a DevOps collaborative environment.

This strategy provided high stability and flexibility in the actual operational environment and formed a basis that quickly diagnosed problems and prevented service spread during failures.

## 8. Design Insights and Philosophy

- The message-based structure is not just a communication means but a strategic structure that considers operational efficiency and system scalability simultaneously. Additionally, the message flow was designed as a unit that both developers and operators could interpret, inherently embedding a communication foundation from a DevOps perspective.
- Namespace separation is a linguistic design tool for clarity in team communication and structure interpretation. It performs a role beyond simple naming conventions, defining functions as a common language and aligning collaboration standards as a foundational agreement in design.
- Architectural design is a process that interprets and structures business requirements beyond mere technical implementation. Past experiences with ROS-based messaging structures were foundational in forming this structured thinking, and designers play a role in coordinating dependencies and flows between system components, thereby designing both technical structures and organizational collaboration.

## 9. Key Messages

> "Good message design ultimately means good operational design."
> 
> "Systems become complex with connections and simplified with messages."