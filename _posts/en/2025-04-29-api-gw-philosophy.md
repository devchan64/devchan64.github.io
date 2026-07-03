---
date: 2025-04-29
layout: post
permalink: /en/2025/04/29/api-gw-philosophy.html
summary: API Gateway is a practical integration point for specification, authentication, and flow control in a distributed API era. Designers design flows, and Gateway should be where that work begins.
tags:
- Design Philosophy
title: Why Should API Gateway Be the Starting Point of Architectural Design?
---

> This article was translated from the original Korean source. The English version was regenerated from the latest Korean document.

---

# Why Should API Gateway Be the Starting Point of Architectural Design?

## 1. Structureless Flow – The Design Problem of the API Era

In modern systems, APIs are no longer just technical elements.  
They sit at the center of business flow, function execution, authentication and security, and data distribution.

However, the reality we face includes:

- Numerous API calls but no flow.
- Documentation exists, but structure does not.
- Authentication occurs, but the boundaries of trust are unclear.
- Calls are possible, but the flow is not interpreted.

In such situations, designers become **unable to describe the structure following the flow**.

> Structure begins with flow.  
> If you cannot describe the flow, you cannot design the structure.

This article explores how to begin **flow-centered architectural design** from a designer's point of view.  
It is also an attempt to reinterpret **API Gateway** as the starting point of that design work.

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

There was no real need to connect them at first.  
**They addressed different kinds of problems, appeared at different times,**  
and systems were not yet complex enough to require tighter integration.

- OpenAPI was a developer's tool for documenting and testing APIs.  
- OAuth was a protocol for delegated authorization and user trust.  
- API Gateway was an operational structure for inter-service routing and version management.

> They were not 'one flow' initially.  
> **They were born separately, not scattered.**

### Why does this separation now feel uncomfortable?

As systems grow and APIs become the center of business,  
designers now need to **interpret and control the entire flow**.

- If specification (OpenAPI), execution (Gateway), and trust (OAuth) move separately,  
  it becomes difficult to understand them as one structure.
- Authentication has been done, but where? Why? How was it delegated?
- Paths exist, but the flow cannot be explained.

> A separation that once caused no problem  
> now appears as the limit of a structure with no flow.

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

Each technology still works.  
- OpenAPI provides declarations,  
- OAuth handles authentication and delegation,  
- Gateway handles routing.

But if they do not connect as one flow,  
**designers can neither explain the structure nor trace problems through it.**

- Authentication occurred, but on which path and under what conditions?
- The call failed, but where was the flow blocked?
- The request was logged, but how is it connected to observability metrics?

### Technical decisions emerged that could reconnect the flow

Flow is not just a concept.  
Actual **technical points have emerged where reconnection becomes possible.**

- OpenAPI has moved beyond documentation,  
  making it possible to derive Gateway configuration and authentication flow from declarations.
- OAuth has enabled authentication integration and user information propagation within the Gateway.
- Observability can now connect trace IDs at the API Gateway level,  
  making request flow visible through distributed tracing.

Flow is now **not just a theory, but an executable structure**.  
Designers become the **decision-makers who weave previously disconnected elements into one flow**.

---

## 4. API Gateway Was Not Defined by Simple Functions

At first, API Gateway was little more than a routing tool.  
- It accepted API requests split across microservices,
- forwarded them to each service,
- and served as a **proxy** that separated versions and routes.

However, as systems expanded and became more complex,  
the Gateway could no longer remain just a simple function.

### Expanding Role at the Center of Flow

- **Starting point of the path**: The URI is now part of the design.  
  Predictable patterns, traffic distribution strategies, and caching policies all depend on URI design.

- **Decision point for authentication**: The location and method of authentication,  
  whether OAuth, JWT, IAM, or something else, should be handled or delegated at the Gateway layer.

- **Aggregation point for observability**: Requests and responses, latency and failures, trace IDs and correlation IDs  
  all pass through Gateway as traces of the flow.

### Designers are the people who shape this flow

The API Gateway has now become the point where **the structural intentions of the design are implemented**.

- Designing the start and end of the flow,  
- defining the trust boundary for authentication,  
- and setting the request pattern and observability boundary  
  all happen at Gateway.

> Gateway is not just a place for settings.  
> It is **a design tool that turns flow into structure**.

---

## 5. Where Should Designers Start Practicing

Design is not an abstract plan but  
**a practice that crystallizes flow into structure**.

API Gateway is the first point where that practice begins,  
and designers structure the flow through three architectural judgments.

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

- How should authentication methods such as JWT, OAuth2.0, and IAM be selected and placed?
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

> A flow that cannot be observed cannot be controlled,  
> and a system that cannot be controlled is a system that was never truly designed.

### These three areas must be connected

- Route design determines the authentication flow,  
- and the authentication structure becomes a prerequisite for the observability strategy.  
- Only when all three are designed together  
  can **flow-centered architecture be completed**.

> API Gateway is the execution point where these three flows meet,  
> and it becomes a design tool through which a designer's judgment can be unfolded concretely.

---

## 6. Move Beyond Misunderstanding and Toward Structure

For many developers, API Gateway is still understood as  
**a configuration tool that brokers traffic**.

- timeout settings
- authentication bypass handling
- dynamic routing
- Lambda integration or cache settings

Those functions are clearly important.  
The problem is that **they are often repeated without structure**.

### Features get repeated, but the structure is never designed

Gateway gets used,  
but designers cannot explain **why the flow was configured that way**.

- Calls are possible, but the flow is not interpretable.  
- Authentication works, but there is no trust boundary.  
- Logs remain, but structure does not appear.

> Feature-centered configuration can be executed,  
> but structure-centered design must be explainable.

### We need a shift toward structural thinking

Gateway must now be seen  
not as a pile of settings,  
but as **the point where a designer's structural judgment is embodied**.

- Why was this URI pattern chosen?  
- Why was authentication placed at this point?  
- Why does branching happen here, and according to what observability criteria?

Only when those questions can be answered  
does Gateway become **structure rather than settings**.

> Gateway is no longer just a DevOps tool.  
> It is **a designer's tool** for controlling flow,  
> explaining structure,  
> and producing executable design.

---

## 7. A Design Strategy That Starts with Gateway

Flow is no longer explained through documents alone.  
Designers now need to use API Gateway to **connect declared specifications to executable structure**.

This process can be framed as a **practical structural strategy** that organizes three flows around Gateway: definition, authentication, and observability.

### 1. Connect declared structure to execution (OpenAPI → Gateway)

- API Gateway configuration can be imported or automated from OpenAPI.
- AWS API Gateway, Google Cloud Endpoints, Kong, and Apigee all officially support routing and authentication integration based on OpenAPI.
- That makes it possible to take a first practical step from specification toward executable structure.

### 2. Authentication must be decided inside the flow

- Authentication is not a simple yes-or-no concern.  
  What matters is where, by whom, and under what conditions it is applied.
- Gateway-level design should determine:
  - which authentication model to use: JWT, OAuth2.0, IAM, and so on
  - where authentication lives: inside Gateway or in a Lambda Authorizer
  - the scope of trust delegation: the entire internal system or only part of the external client boundary

### 3. Observability is the tool that makes flow interpretable

- Logs and metrics that carry real structural meaning  
  should start at Gateway.
- Core design elements include:
  - assigning trace IDs and correlation IDs
  - tracking branches by response code
  - organizing metrics such as latency and failure rate
  - integrating with external visualization systems such as AWS CloudWatch, ELK, and Datadog

> This is not a simple checklist of features.  
> It is **a practical starting point designers can use to turn flow into structure**.
>
> To choose Gateway as the starting point means  
> designing the structure so that specification, trust, execution, and interpretation are **connected within one flow**.

---

## 8. Conclusion – Structure Is Decided at the Starting Point

Systems open through APIs,  
and design begins by reading flow.

API Gateway is not merely a tool for passing requests onward.  
It is now the point where a designer can **explain and control flow as structure**.

### The language of the designer is flow

- Swagger, OpenAPI, and OAuth all began as declarations.  
- But declarations alone are not enough to operate a system.
- **Executable structure**, **interpretable flow**, and **trustworthy authentication boundaries**  
  must be integrated inside one structure.

### Gateway is where that structure begins

- API Gateway is now  
  **an integrated design point** where URI, authentication, and observability are designed together.
- It is the designer's first practical workspace,  
  connecting declaration to execution, flow to structure, and structure to interpretation.

> Structure does not begin with documents. It begins with flow.
>
> Designers assemble flow,  
> and Gateway becomes **the structural origin point** that makes that flow work in reality.

> **API Gateway is the first place where the intentions of a structural designer are realized.**

---

## References and Citations

### A. Starting points of each technology

- Tony Tam, *“Swagger: Simplifying API Development for Everyone”*, launch announcement for the Swagger project (2011)  
  ↳ Later evolved into the OpenAPI Initiative: [https://swagger.io/specification/](https://swagger.io/specification/)

- Early OAuth 1.0 proposal: Blaine Cook, Leah Culver, et al., *OAuth Core 1.0* (2007), see IETF RFC5849  
  ↳ Summary of OAuth history: [https://oauth.net/core/1.0/](https://oauth.net/core/1.0/)

- Amazon API Gateway launch (2015): *Amazon API Gateway – Create, Publish, Maintain, Monitor, and Secure APIs at Any Scale*  
  ↳ Official documentation: [https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html)

---

### B. Why structural integration became necessary

- Martin Fowler, *Microservices* (2014): explains API-distributed structures created by microservice adoption  
  ↳ [https://martinfowler.com/articles/microservices.html](https://martinfowler.com/articles/microservices.html)

- Google Cloud Docs: *API Design Guide*, emphasizing integration across specification, authentication, and structure  
  ↳ [https://cloud.google.com/endpoints/docs/openapi](https://cloud.google.com/endpoints/docs/openapi)

---

### C. OpenAPI → executable structure examples

- AWS API Gateway official docs: *Import a REST API using OpenAPI*  
  ↳ [https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-import-api.html](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-import-api.html)

- Google Cloud Endpoints official docs: *Using OpenAPI with ESP*  
  ↳ [https://cloud.google.com/endpoints/docs/openapi/get-started-cloud-functions](https://cloud.google.com/endpoints/docs/openapi/get-started-cloud-functions)

- Kong and Apigee: examples of OpenAPI-based configuration  
  - Kong Dev Portal: [https://docs.konghq.com/](https://docs.konghq.com/)  
  - Apigee Docs: [https://cloud.google.com/apigee/docs](https://cloud.google.com/apigee/docs)

---

### D. Flow-centered design guidelines

- AWS Well-Architected Framework – AWS Serverless Lens  
  ↳ [https://aws.amazon.com/ko/blogs/korea/new-serverless-lens-in-aws-well-architected-tool/](https://aws.amazon.com/ko/blogs/korea/new-serverless-lens-in-aws-well-architected-tool/)

- Google API Design Guide: guidance on URI design and authentication boundaries  
  ↳ [https://cloud.google.com/apis/design](https://cloud.google.com/apis/design)

- Microsoft REST API Guidelines: emphasis on OAuth integration and specification-centered design  
  ↳ [https://github.com/microsoft/api-guidelines](https://github.com/microsoft/api-guidelines)

---
