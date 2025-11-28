---
date: 2025-04-29
layout: post
permalink: /en/2025/04/29/api-gw-philosophy.html
summary: API Gateway는 선언(OpenAPI), 인증(OAuth), 흐름 제어가 분산된 시대를 통합하는 실천 도구다. 설계자는 흐름을
  설계하는 사람이며, 그 시작점은 Gateway가 되어야 한다.
tags:
- Design Philosophy
title: Why Should API Gateway Be the Starting Point of Architectural Design?
---

> `gpt-4-turbo` has translated this article into English.

---

# Why Should API Gateway Be the Starting Point of Architectural Design?

## 1. Structureless Flow – The Design Problem of the API Era

In modern systems, APIs are no longer just technical elements.  
They have become central to business flows, function calls, authentication and security, and data distribution.

However, the reality we face includes:

- Numerous API calls but no flow.
- Documentation exists, but structure does not.
- Authentication occurs, but the boundaries of trust are unclear.
- Calls are possible, but the flow is not interpreted.

In such situations, designers become **unable to describe the structure following the flow**.

> Structure begins with flow.  
> If you cannot describe the flow, you cannot design the structure.

This article discusses how to start **flow-centric structural design** from a designer's perspective.  
And it attempts to reinterpret the **API Gateway** as that starting point.

---

## 2. Declaration, Authentication, Control – Technologies Started as Solutions to Individual Problems

The core elements of the API technologies we use,  
namely **OpenAPI**, **OAuth**, **API Gateway**,  
were not designed as a unified structure from the beginning.

Each technology started **to solve different problems independently**.  
They emerged according to the demands of the times as follows:

| Technology | Purpose | Start Time | Initial Goal |
|------------|---------|------------|--------------|
| **Swagger / OpenAPI** | API specification declaration | 2011 (Tony Tam) | API documentation and test automation |
| **OAuth** | Authentication delegation | 2007–2010 | Allowing third-party access without user passwords |
| **API Gateway** | Flow control / Routing | 2014–2015~ | Traffic distribution and API routing as an L7 proxy |

### Why weren't these connected from the beginning?

Truthfully, there was no need to connect them.  
**The nature of the problems was different, and their emergence times varied,**  
and the systems were not complex enough to consider each other.

- OpenAPI was a developer's tool for documenting and testing APIs.  
- OAuth was a security protocol for authorization and user permissions.  
- API Gateway was an operational structure for inter-service routing and version management.

> They were not 'one flow' initially.  
> **They were born separately, not scattered.**

### Then why do we now feel uncomfortable with this separation?

As systems grow and APIs become the center of business,  
designers now need to **interpret and control the entire flow**.

- If specifications (OpenAPI) and execution (Gateway), trust (OAuth) move separately  
  → It becomes difficult to understand as one structure.
- Authentication has been done, but where? Why? How was it delegated?
- Paths exist, but the flow cannot be explained.

> The past separation,  
> **now approaches as the limit of a structureless flow**.

---

## 3. Why Must Systems Converge into a Flow

When systems were small and simple,  
it was not a problem for documentation, authentication, and routing to operate separately.  
However, as APIs have become **the main route and business interface** of services,  
designers increasingly feel the need to **describe the entire flow as one structure**.

### What is flow?

Flow is **the entire process a single request goes through in the system**:

- What path did it enter through? (Route)
- How was it authenticated? (Auth)
- What resources did it pass through, and what response was received?
- Where did the request fail, and what logs did it leave? (Observability)

This flow must be **clearly designed and connected**  
so that designers can understand, control, and improve the system.

### The problem is the 'disruption of flow'

Each technology still works well.  
- OpenAPI provides declarations,  
- OAuth performs authentication,  
- Gateway handles routing.

However, if these do not connect as one flow,  
**designers cannot describe the structure or trace the problems.**

- Authentication occurred, but on which path and under what conditions?
- The call failed, but where was the flow blocked?
- The request was logged, but how is it connected to observability metrics?

### Decisions were made to reconnect the flow

Flow is not just a concept but  
actual **technical points where reconnection is possible have emerged.**

- OpenAPI has moved beyond simple documentation,  
  allowing Gateway settings and authentication flows to be derived from declarations.
- OAuth has enabled authentication integration and user information propagation within the Gateway.
- Observability metrics are linked at the API Gateway level with Trace ID,  
  and the request flow can be visualized through a distributed tracing structure.

Now flow is **not just a theory but an executable structure**.  
Designers have become the **decision-makers who weave disconnected elements into one flow**.

---

## 4. API Gateway Was Not Defined by Simple Functions

Initially, the API Gateway was just a simple routing tool.  
- It received API requests divided by microservices,
- forwarded them to each service,
- and distinguished versions and paths as a **proxy role**.

However, as systems expanded and became more complex,  
the Gateway could no longer remain just a simple function.

### Expanding Role at the Center of Flow

- **Starting point of the path**: The URI is now part of the design.  
  Predictable patterns, traffic distribution strategies, and caching policies all depend on URI design.

- **Decision point for authentication**: The location and method of authentication,  
  such as OAuth, JWT, IAM, should be processed or delegated at the Gateway level.

- **Convergence point of observability**: Requests and responses, delays and failures, Trace ID and Correlation ID—  
  all traces of the flow pass through the Gateway.

### The designer handles this flow

The API Gateway has now become the point where **the structural intentions of the design are implemented**.

- Designing the start and end of the flow,  
- defining the boundaries of authentication trust,  
- designing the patterns of requests and boundaries of observability—all  
  are executed at the Gateway.

> The Gateway is not just a simple setting,  
> **but a design tool that turns flow into structure**.

---

## 5. Where Should Designers Start Practicing

Design is not an abstract plan but  
**a practice that crystallizes flow into structure**.

API Gateway is the first point where this practice begins,  
and designers compose the flow through the following three structural judgments.

### 1. Path Design (Route Design)

- The URI is not just an address but **the starting point of the flow**.
- The following elements influence URI design:
  - API version management
  - Resource structuring (resource-centric)
  - Permission boundaries and role-based access control
  - Multi-tenancy structure
- **Predictable URI patterns** have the following structural effects:
  - Caching policies and validity management
  - Security settings (WAF, IP limitations)
  - Traffic routing optimization

### 2. Authentication Structure

- How to choose and place authentication methods (JWT, OAuth2.0, IAM, etc.)?
- Should authentication be handled within the Gateway,  
  or delegated to an external layer like Lambda Authorizer?
- The important thing is to **structurally determine** within the flow  
  **the location of authentication** and **the scope of trust delegation**.

### 3. Observability Strategy

- A structure that makes the flow of the API system **interpretable** is necessary.
- Key items:
  - Major logs such as request/response codes, call delays, and failure patterns
  - **Distributed tracking** through Trace ID / Correlation ID
  - Real-time metric collection and visualization integration (e.g., AWS CloudWatch, ELK, Datadog)

> An unobserved flow cannot be controlled,  
> and a system that cannot be controlled is an undesi