---
date: 2024-11-01
layout: post
permalink: /en/2024/11/01/message-architecture-and-operational-design.html
tags:
- Project
- DevOps
title: '"Message-Based Architecture and Operations-Centric Design"'
---
> `gpt-4-turbo` has translated this article into English.

## 1. Problem Situation and Crossroads of Choice

In an End-to-End service structure, devices, apps, authentication systems, and data platforms must be organically connected. However, as connectivity increases, disaster resilience and maintainability tend to decrease, and sensitivity to feature changes dramatically increases.

Initially, the system was based on REST API calls, but the following problems continuously occurred:

- Entire services were affected in case of failures
- Close to a monolithic structure, making it difficult to add or change services
- Limited access to information for operators to track or recover from issues

To overcome these structural limitations, it was deemed more appropriate in the long term to transition to a message-centric asynchronous architecture rather than maintain the existing structure.

## 2. Background of Choosing a Message-Based Design

A message-based structure means that each service is not called directly but is indirectly connected through messages and operates independently. The reasons for choosing this structure are as follows:

- **Integrity is more important than real-time performance for business characteristics**
- **Isolation of failures through loose coupling between components**
- **Improved traceability for operators**

Particularly, the message-centric structure has facilitated integration with visualization tools like APM and Grafana, greatly aiding in real-time monitoring and speeding up problem response.

## 3. Design Strategy and Team Acceptance Process

The design was derived based on personal operational experience and past technical backgrounds. In particular, experience with the message-based architecture in the Robot Operating System (ROS) environment was very helpful. ROS is fundamentally organized around a publisher-subscriber message communication structure, emphasizing distributed interaction and resilience among various components.

This technical foundation not only provided simple implementation experience but also played a crucial role in forming a DevOps perspective that considers both operations and development in the actual field. From the early stages of the design, operational feasibility and problem response efficiency were set as core indicators in this project.

Gaining immediate empathy within the organization from the start was challenging. In particular, developers and operators unfamiliar with the message-based structure found it difficult to accept structurally or felt it was more complex compared to the existing REST-based architecture.

Therefore, the key advantages of the design were explained based on practical operational scenarios:

- **Cost Reduction**: Utilizing managed services like AWS Kinesis reduced infrastructure operational costs and manpower burden.
- **Ease of Problem Tracking**: Enhanced operators' problem analysis speed through trace ID-based log search and providing a message list.
- **Secured Scalability**: The message queue-based structure allowed horizontal scaling at the consumer level, effectively responding to service increases.

These advantages formed the basis for repeatedly explaining the effectiveness and benefits of the message-based architecture, building consensus within the team.

> This design was an attempt to implement not just a simple messaging path cleanup, but an integrated structure centered on operational resilience, flexible scalability from a design perspective, and business flow-oriented structuring.
>

## 4. Namespace-Based Hierarchical Structure and Design Philosophy

```plaintext
※ Note: The `data_service` area is not defined in this structure. 
This was a strategic choice considering the possibility of future integration into `data_platform` due to the unclear role and responsibility of that layer at the time.
```

- `3rd_party.`: External system integration area
- `device.`: User access and device control interface
- `service_platform.`: Layer centered on authentication, gateway, messaging, and business logic
- `data_core.`: Data processing layer responsible for log collection, storage, ETL, and analysis

This namespace-based separation goes beyond simple directory distinctions, serving as a method for tagging or grouping functions, which has been practically helpful in tracking the functional layer structure and clearly understanding the system flow. However, more important than the structure itself is whether **these namespaces have been defined and agreed upon as a common language within the team**. Consistency in linguistic alignment and clear meaning assignment are key elements in intuitively interpreting relationships between system components and significantly enhancing communication efficiency between developers and operators.

## 5. Architecture Diagram

The diagram below visually represents the hierarchical composition and message flow of the entire system. It structurally explains how user requests and external events are introduced and processed.

```d2
device.hw -- service_platform.auth -- service_platform.core
device.app -- service_platform.auth -- service_platform.api_gateway

3rd_party.app -- 3rd_party.cloud
3rd_party.hw -- 3rd_party.cloud
3rd_party.cloud -- service_platform.core

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

## 6. Key Design Components

> Note: Initially, the introduction of Kafka was considered, but AWS Kinesis-based managed services were chosen considering infrastructure management efficiency and manpower costs.
> 

### Message Processing Flow

- Asynchronous event flow configured through MQTT and Amazon Kinesis
- Each service is connected in a message subscription manner, blocking failure propagation

### Domain-Based Layer Separation

- Roles such as authentication, gateway, and messaging are distinguished and managed within `service_platform`
- Product domains are placed in container units after the API Gateway, securing a structure that is easy to delete and replace

### Data Flow and Post-Processing Structure

- Configuring a flow through `data_core` from data collection → ETL → statistics/analysis
- Plans to expand into a `data_platform` form integrating `data_service` later

## 7. Operational Performance and Effects

- **Secured Observability**: Integration with APM, trace ID, Grafana, etc., has enabled real-time monitoring, allowing rapid tracing of causes by flow when problems occur. Previously, it took hours to analyze the cause of a failure, but after the introduction of a message-based structure, it became possible to understand and respond to key flows within minutes.
- **Improved Resilience**: Pre-designed automatic reprocessing and recovery flows allowed localized handling of issues without affecting the entire service.
- **Maintenance Convenience**: Enhanced operator accessibility through message tracking, logging, and message list management, forming a structure where operators and developers could discuss issues on the same standards.
- **Established DevOps Collaboration Foundation**: The message-based structure enabled operators and developers to understand and discuss the system based on the same message flow and structure, positively impacting the establishment of a DevOps collaboration environment.

This strategy provided high stability and flexibility in the actual operational environment and formed a foundation that quickly diagnosed problems and prevented service spread in disaster situations.

## 8. Design Insights and Philosophy

- The message-based structure is not just a means of communication but a strategic structure considering operational efficiency and system scalability simultaneously. Additionally, the message flow was designed as a unit that can be interpreted together by developers and operators, inherently incorporating a communication base from a DevOps perspective.
- Namespace separation serves as a linguistic design tool for clarity in team communication and structure interpretation. It performs a role beyond simple naming conventions, defining functions as a common language and aligning collaboration standards through design consensus.
- Architectural design is a process of interpreting and structuring business requirements beyond technological implementation. Past experiences with ROS-based messaging structures laid the foundation for forming such structured thinking, and designers, by coordinating dependencies and flows between system components, realized the need to design both technical structures and organizational collaboration simultaneously.

## 9. Core Messages

> "Good message design is ultimately good operational design."
> 
> 
> "Systems become complex with connections and simplified with messages."