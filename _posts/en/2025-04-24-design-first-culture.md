---
date: 2025-04-24
layout: post
permalink: /en/2025/04/24/design-first-culture.html
tags:
- Design Philosophy
title: '"The Changing Role of Code Conventions and the Shift to a Design-First Development
  Culture"'
---

> `gpt-4-turbo` has translated this article into English.

---

# 1. Code Conventions, Are They Still Important?

Indentation, bracket placement, variable names.  
Are you still reviewing these aspects?

For a long time, we have regarded code conventions as an important standard for collaboration order.  
Unifying style and enhancing code readability have been considered virtues in developer collaboration.

However, we now find ourselves asking again.  
Is this truly the core issue we need to agree upon?

Automatic formatters align most styles automatically,  
and AI generates code without specifications.  
The focus of collaboration is shifting from code to API specifications, diagrams, and documentation.

In this flow, I have come to realize that code conventions are gradually losing their central role.

So, what standards should we focus on for collaboration moving forward?

This article follows the flow below:

- How code conventions emerged and why they are losing influence
- How API specifications became a standard for collaboration
- What aspects of design cannot be explained by API specifications alone
- What should the development culture we create and maintain look like

It is time to redefine our philosophy.  
Now, we must be able to explain "why we made it this way" rather than just "how we wrote the code."

---

# 2. Code Convention, API-First, Design-First — Concepts and Background

The three concepts discussed in this article are all practical strategies that have emerged as collaboration methods have evolved.  
Each term is not just a simple trend, but a response to the increasing complexity of the development environment.

### Code Convention

- **Background**: As collaboration scale grew, readability issues arose in code.
- **Role**: Unifying style, providing review standards, ensuring maintenance consistency.
- **Turning Point**: The popularization of automatic formatter tools, AI code generation, and the fading of style discussions.

→ Currently, the area has transitioned to a level handled automatically by tools.

### API-First

- **Background**: Frequent conflicts arose from the lack of contracts in collaboration among clients, servers, and multiple teams.
- **Role**: Specification-based contracts, automated collaboration, and foundation for parallel development.
- **Expansion Factors**: Development of tools like Swagger (OpenAPI), Postman, Contract Testing.
- **Limitations**: It defines "what to create," but cannot explain "why it was created this way."

### Design-First

- **Background**: Increase in domain complexity, difficulty in sharing design decisions through API specifications alone.
- **Role**: Defining design structure, responsibility separation, and basis for decision-making before coding.
- **Expression Proliferation**: Around 2016, terms like Stoplight and SwaggerHub formalized the term Design-First.
- **Current**: Settling into a design-centered collaboration culture, diversifying into practice units (ADR, RFC, etc.)

| Category      | Core Question             | Collaboration Focus | Reason for Transition |
| ------------- | ------------------------- | ------------------- | --------------------- |
| Code Convention | How was it written?      | Style              | Replaced by automation |
| API-First     | What is to be made?       | Interface          | Demand for parallel development |
| Design-First  | Why was it made this way? | Structure and Intent | Need to address complexity |

> This flow demonstrates the evolution of collaboration units from code → interface → design decisions.

---

# 3. How is the Structure of Collaboration Changing?

Past collaboration centered around the code itself.  
Aligning on which style to write in, how to format and name, was seen as a symbol and essential condition of teamwork.

However, today, the structure of collaboration is gradually losing its focus.

- Automatic formatters have removed most style discussions
- AI generates code irrespective of conventions, shaking the standards of review
- Many startups prioritize feasibility and speed over style through rapid experimentation and disposal

This change is moving the standards of collaboration from code style to **interface specifications**, and even more fundamentally, to **design structure and decision-making**.

- What features to create (API specifications)
- Who will take responsibility (domain model)
- Why it was designed this way (decision records)

Collaboration is now evolving into a structure where understanding and sharing "why it was made this way" is more critical than "how it was written."

> Code-centric collaboration is fading,  
> and now a structure that shares the flow of judgments and design is necessary.

---

# 4. API-First: Technical Standardization of Communication

As collaboration scales and systems become more complex,  
developers can no longer maintain efficient collaboration simply by "writing code first and aligning later."

This problem led to the emergence of the API-First approach.  
This involves defining **interface specifications first** before feature implementation, and developing in parallel based on these specifications.

## Changes Brought by API-First

### Interfaces Become Contracts

Using specification formats like OpenAPI, GraphQL, gRPC provides consistent collaboration standards.

### Development Becomes Parallel

Clients and servers can work independently based on specifications.  
Tools like Mock servers, automated documentation, and test stub generation support this.

### Communication Shifts to Center Around Specifications

Instead of discussing based on implemented code like in the past, decisions are made around specifications and design standards.

This method has brought clear improvements in efficiency and productivity.  
However, it also has an important limitation.

While API specifications can describe "what to make,"  
they fail to explain "why it was made this way."

- Why domain boundaries are divided this way
- Why a particular function is handled by this service
- The context in which API changes were decided

Most of the basis for these decisions exists outside the specifications and can be unshared, forgotten, or undocumented.

> Thus, we feel the need to move beyond specification-centered collaboration,  
> to a structure that shares the flow and judgments of design.

---

# 5. Design-Centered Development: A Strategic Flow to Address Complexity

As domains become more complex, what's needed in collaboration goes beyond simple code sharing or interface specifications.

As features increase,  
teams diversify,  
and services separate,  
developers feel the necessity to share not just code, but **structure** and **the flow of decisions**.

The practice being implemented in this context is  
design-centered development,  
often called 'Design-First,' though recently it has been divided into more specific practices.

## Key Elements in Design-Centered Development

- **Domain Modeling**  
  → Segments system functions and responsibilities, setting structural boundaries.

- **Visualization of Design Flow**  
  → Documents structural understanding necessary for collaboration, such as sequence diagrams, state transitions, and component configurations.

- **ADR (Architecture Decision Record)**  
  → Clearly records the reasons for choosing specific structures or technologies, the alternatives considered, and the context.

- **RFC-based Design Collaboration**  
  → Documents design proposals and feedback between teams, managing them in a reviewable format.

Design-centered development means more than just defining APIs first.  
It involves describing the structure in a way that is understandable and ensuring that the entire team shares this understanding.

The implementation through code is merely the result of a structure that has already been decided.

> More important than "what was made"  
> is the "why it was made this way" that can be explained through structure.

---

# 6. How Should Our Culture Change Moving Forward?

As the development environment becomes more complex and the entities involved in collaboration diversify, what we need is not a culture of aligning code styles but one of **sharing a discernable structure and the flow of decision-making**.

The way we collaborate has changed.  
Now, a transition to a corresponding development culture is necessary.

## Collaboration Methods We Need to Develop

- **Leave code style to tools**  
  → Use automated formatters like Prettier, Black, gofmt to eliminate style debates.

- **Contract interfaces through specifications**  
  → Utilize OpenAPI, GraphQL, Protobuf, etc., to base collaboration on clear contract standards.

- **Record design decisions**  
  → Use ADRs, RFCs, etc., to share the background and context of design decisions.

- **Agree on responsibilities and structures at the design stage**  
  → Use domain modeling and component partitioning to clarify team responsibilities and collaboration structures.

We can no longer afford to work in a collaboration style that involves:

- Discussing variable names
- Reviewing formatting
- Guessing the intent of features

Moving forward, we need a system that can explain "why it was made this way" rather than just "what was made."

> Design is now the starting point for collaboration,  
> and a culture that shares that design is directly linked to the team's scalability and maintainability.

---

# 7. What Should We Agree Upon?

Code convention has long been an important tool for creating order in collaboration.  
And it still functions as a valid norm today.

However, I increasingly feel that many teams are now centering their collaboration around  
**the structure and flow of design judgments** rather than just code style.

Automated formatters,  
AI-based code generation,  
and development methods centered on API specifications  
are shifting the standards of collaboration from code to specifications,  
and from specifications to design.

What we need to agree upon moving forward is not just consistently written code.

- A clear interface on what to create
- A structural judgment on why it was created this way
- And a culture on how these judgments should be recorded and shared

I have been talking about the importance of structure.  
I have been saying that Design-First is necessary.

It is still a time of unfamiliar thinking.

That's why I write this article again.  
Because I believe it is time to continue spreading and persuading these ideas.

> Code conventions have been replaced by tools.  
> What we truly need to agree upon is  
> **not code, but structure, and not implementation, but a flow of discernible design decisions**.

---

## Attachment: Historical Overview of Code Convention, API-First, Design-First

### Code Convention

| Year   | Event/Trend                                                                  |
| ------ | ---------------------------------------------------------------------------- |
| 1968   | Edsger Dijkstra advocates structured programming (“Go To Statement Considered Harmful”) |
| 1974   | Kernighan & Plauger publish "The Elements of Programming Style"               |
| 1978   | Emergence of K&R C style, followed by conventions for various languages      |
| 1990s  | Spread of language-centric style guides for Java, C++, Python, etc.          |
| 2010s  | Introduction of automated linters/formatters like ESLint, PEP8, gofmt        |
| 2020s~ | Establishment of tool-centered automatic formatting with Prettier, Black, clang-format |

→ Conventions are increasingly being maintained by tools rather than people.

### API-First

| Year      | Event/Trend                                                                |
| --------- | -------------------------------------------------------------------------- |
| Early 2000s | Emergence of SOAP/XML-based web APIs (Salesforce, eBay, Amazon, etc.)      |
| 2011      | Swagger (later OpenAPI) released: Start of specification-based API development |
| 2014~2017 | Publication of corporate standards like Google Cloud API Design Guide, Microsoft REST Guidelines |
| 2016      | Swagger reestablished as OpenAPI under the Linux Foundation's management  |
| 2018~     | Spread of API design/documentation tools like Stoplight, Postman, Pact    |

→ API specifications become contracts for collaboration and the basis for parallel development.

### Design-First

| Year          | Event/Trend                                                                |
| ------------- | -------------------------------------------------------------------------- |
| Early 2010s   | Discussions on system structure design culture alongside Domain-Driven Design (DDD) |
| 2015          | Spread of ADR (Architecture Decision Record) culture (Michael Nygard et al.) |
| 2016~2017     | Use of the term "Design-First" starts in API design tools like Stoplight, SwaggerHub |
|               | Specifying 'design prioritization' as a concept extending beyond API-First development |
| 2016~2020     | Demand for "records of intent and design" rises within the API-First flow   |
| 2020s         | Establishment of practice-oriented tools like RFC-based collaboration, domain modeling, design visualization |

→ Establishing a culture of "structural consensus before API specifications."

> These three concepts have all evolved in response to **increasing complexity in the development environment** and **changes in the units of collaboration**.

---

## Attachment: What is an RFC (Request for Comments)?

**RFC** (Request for Comments) is a document written within a team or organization to propose new designs, policies, or structural changes and receive feedback.

### Purpose

- To **formally propose** specific features or structural changes
- To **gather feedback** from various members
- To **develop coordinated design plans** through this process

This is not just a simple idea memo but a **document-based communication method** for consensus-based design within an organization.

### Typical Uses

- To share feature or architecture changes in advance
- To drive feedback and discussions based on documentation
- To clarify the review and approval process
- Final design plans remain as references for future use

### Example Format

- Title and number
- Proposer and date of writing
- Background of the change proposal
- Specific design or policy content
- Expected impacts and alternatives
- Feedback log and decisions

RFCs are not just documents; they are tools that **explicitly manage the team's judgments and design processes**.

---

## Attachment: What is an ADR (Architecture Decision Record)?

**ADR** (Architecture Decision Record) is a document that clearly records the background, reasons, and alternatives for specific decisions made during the design or configuration of a software system.

### Purpose

- To state **why a particular structure or technology was chosen**
- What **solution it provided to a problem**
- What **alternatives were considered and why they were not selected**

This helps understand the intent of the design even as time passes.

### Typical Uses

- Continuously written not just at the project's start but also throughout development
- Decisions are recorded accumulatively by version, and change histories are also managed
- ADRs help maintain design consistency and leave a basis for decision-making

### Example Format

- Decision title and identifier
- Status (e.g., Proposed, Approved, Deprecated, etc.)
- Context: What issue existed
- Decision: What choice was made
- Rationale: Why it was made
- Alternatives: What was considered and why it was not chosen
- Follow-up actions or related documents

ADRs help the team explain "why it was made this way" by serving as a recording device.  
They ensure that technical decisions remain not just in personal memory but as an asset of the organization.