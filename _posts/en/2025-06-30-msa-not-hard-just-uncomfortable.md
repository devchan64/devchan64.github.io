---
date: 2025-06-30
layout: post
permalink: /en/2025/06/30/msa-not-hard-just-uncomfortable.html
summary: MSA는 기술적으로 어려운 것이 아니라, 구조 안에서 책임을 받아들이는 일이 불편하기 때문에 어렵게 느껴진다고 생각합니다. 이 글은
  MSA를 직접 실행하며 얻은 경험과 해석을 바탕으로 그 본질을 다시 정리합니다.
tags:
- Design Philosophy
- Organizational Culture
title: MSA Does Not Increase Costs; It's Just Inconvenient.
---

> `gpt-4-turbo` has translated this article into English.

---

## Preface

Many people talk about MSA.  
They say to separate services and emphasize clear contracts.  
Advice also does not omit dividing responsibilities and localizing failures.

However, as this conversation continues,  
it is often found that many have not actually implemented these structures.

This article organizes some small insights and interpretations gained through structuring and operating MSA directly,  
forming actual teams, experiencing failures, and through the process of separating and reintegrating systems.

The perception that MSA is difficult,  
claims that initial adoption costs are high,  
and concerns that it burdens the organization.

We want to calmly examine where these claims come from,  
and what fears and avoidance are hidden behind them,  
from the perspective of someone with experience.

> **MSA is not difficult. It's just uncomfortably transparent.**

---

## Is MSA Really Difficult?

Many organizations hesitate to adopt MSA.  
"It costs a lot," "the structure is complex," "it's not suitable for early startups," are common concerns.

But looking back at the cases I've experienced,  
it seems that these judgments did not solely originate from the structural limitations of MSA itself.

From what I've observed,  
- a culture where responsibilities are not clearly divided,  
- unclear contractual relationships,  
- code structures that easily hide problems,  
- an atmosphere that resists experimentation,  
often caused more costs.

> **The feeling that MSA is expensive may be because the structure is transparent.**  
> Previously unseen inefficiencies could have become apparent.

If we had started with a modularized structure from the beginning,  
small failures could have been easily fixed, and  
new attempts could have been made without much burden.

Ultimately, the issue was closer to the attitude and mindset of accepting the transparency revealed by the structure than the structure itself.

---

## It Wasn't Scary Because We Started with Modules

Designing a perfect structure from the beginning is difficult.  
However, a deletable structure, a design with separated boundaries,  
and a mindset that it can be recreated at any time were sufficiently prepared.

During the initial development phase, we chose to divide functions into module units.  
We separated each function into independent files and tried to keep execution units small.  
As a result, we could respond by replacing or removing only the problematic module without discarding the entire system.

This approach eventually made a structure where we didn't have to be too afraid of failures.  
- Refactoring was freely performed,  
- A/B testing could be attempted relatively easily,  
- The scope of code responsibilities gradually became clearer,  
- The structure was refined through repetitive experiments.

The starting point of these results was 'modular thinking.'

In fact, the mindset of dividing into module units was not special.  
Windows OS's DLL, Java's ClassLoader, Python's `importlib` and others  
also followed the same principle long ago.  
About 15 years ago, a module loader I personally implemented was also in this flow.

> **A dynamically loadable structure** means more than just technical convenience.  
> It was an approach that allowed for failure, creating structural leeway.

MSA did not start based on a grand framework from the beginning.  
Rather, it started from a somewhat outdated but flexible method, and  
ultimately, I felt it secured higher resilience at a lower cost.

---

## It's Not the Technology That's Hard, But the Attitude

Often, people say MSA is difficult.  
API gateways, inter-service authentication, message brokers, CI/CD, container orchestration, etc.  
There are many technical elements to learn.

Of course, there's a lot to learn.  
But over time, you realize:  
These technologies have well-organized documentation, examples, and active communities.  
Eventually, these are areas that can be mastered with time.

What's harder is not the technology, but the **attitude**.

MSA is not only a technical structure but primarily presupposes an attitude of **distributing responsibilities, respecting boundaries, and adhering to contracts**.  
And this responsibility involves discomfort.

- When responsibilities become clear, avoidance is difficult.  
- When interfaces are sorted, excuses are reduced.  
- When a monitoring system is set up, the phrase "I didn't know" loses credibility.

The reason MSA feels difficult is not so much due to the technical difficulty of the technology itself but because **it confronts the attitude required by that structure**.

> **The structure is a device that reveals responsibility, and MSA does not hide it.**

---

## What's Needed Is Not Technology, But the Realization That It's Needed

Dividing the structure itself is not difficult.  
Designing APIs, separating services, and deploying with containers are tasks well within the reach of skilled developers.

However, continuously operating, maintaining, and making the structure scalable  
cannot be achieved by technology alone.  
At its core, **culture** was present.

MSA asks people through the structure:  
- Do you know what your responsibilities are?  
- Are you calling services that don't need to be called?  
- When the contract changes, who and how should you communicate?

Ultimately, MSA is not just a matter of technology adoption or structural design, but a problem of a **culture that divides responsibilities, moves based on trust, and trains autonomy**.

If the structure is adopted without forming this culture,  
MSA can instead induce greater complexity,  
making it difficult to identify the causes of problems,  
and increasing fatigue within the team.

Therefore, more important than the adoption of technology itself is understanding why that structure is necessary and  
creating a cultural awareness that can be shared by all.

> **MSA is a process of agreeing on a way to live together before designing the structure.**  
> In it, people learn responsibilities, repeat collaboration, and build trust.

---

## The Real Reason Communication Costs Increase

MSA was originally proposed as a structure to reduce communication costs.  
Each service has clear boundaries, teams autonomously take responsibility, and  
it's designed to allow independent development and deployment without unnecessary coordination.

However, in reality,  
I often hear that communication costs have actually increased.

Why is that?

I think there are two reasons.

### 1. Because boundaries were divided based on functions, not responsibilities
In many cases, service boundaries are divided based on the following criteria:

- Let's separate it because it has a lot of traffic
- Since authentication is a common feature, let's make it a module
- Just as the front and back are divided, let's separate the APIs

However, these criteria are based on 'function' units, not 'responsibility' units.
As a result, when actual failures or changes occur,
situations arise where it's unclear who is responsible for what.

> **Services should be bounded based on responsibility.**  
> Functional separation is just a means, not a criterion for dividing responsibilities.

- Services are divided,
- Responsibilities are blurred,
- Call flows overlap,

and inter-service consultations actually increase.

Eventually, a service structure with incorrectly drawn boundaries can explode communication costs instead of reducing them.

### 2. Because the purpose of 'why divide' was forgotten
MSA's purpose is not **"to divide small,"** but  
**"to make it possible to move independently."**

However, if this purpose becomes vague during implementation,
only a structure of 'small services lined up' remains.

- Small but strongly intertwined services
- A structure where multiple teams need to coordinate even for small changes
- Test and deployment are not independent but rather difficult to synchronize

This result appears when we obsess over the word "Micro" and lose sight of "why divide."

Ultimately, the experience of increased communication costs is not a failure of the structure but because **responsibility and purpose were not considered together in establishing the structure**.

---

## Education is an Inevitable Cost

Conversations related to the adoption of MSA often feature the same concerns:  
namely, that "education costs are too high."

Changing the structure requires retraining the team,  
people's mindsets need to change, and  
it can feel burdensome to have to master new tools instead of familiar ones.

These concerns are understandable.  
But it's worth asking one question.

> **Really, was the monolithic system operated without any training?**

I think that's not the case in reality.  
The monolithic system also presupposed many informal educations in the following forms:

- Unwritten rules,
- Information passed verbally,
- Undocumented dependencies,
- Unclear responsibility distinctions

This method may not have been visible,  
but it continuously **consumed time and energy** within the developer explanations, implicit guesses by new members, and repetitive questions and answers.

It's just that the cost wasn't structurally visible,  
but it has always been there in reality.

MSA is an attempt to **formalize, document, and systematize** these learning costs.  
So while it appears costly,  
it's not a new burden but **a clarification of previously hidden costs**.

Furthermore, such costs will inevitably occur at some point.  
So rather than hastily starting education at the point of structural transition,  
**starting from a structure that presupposes education from the beginning**  
could be a more stable and sustainable choice.

> **Education is an inevitable cost.**  
> It's just a matter of whether to delay it,  
> or to include it in the structure from the beginning.

---

## A Transparent Structure is a Fast Structure

MSA often feels uncomfortable.  
Responsibilities are clearly revealed, boundaries are fixed, and dependencies are starkly exposed within the structure.  
These characteristics can be burdensome.

However, paradoxically, this transparency  
enables **faster decision-making and execution**, as experienced.

When the structure is transparent, there's little room for avoidance.  
- The location of bottlenecks can be quickly identified,  
- Points of delayed response can be easily traced,  
- Broken contracts are clearly exposed.

In such a structure,
- The number of communications decreases,
- The time spent on consultations shortens,
- Decision-making naturally disperses.

MSA inherently incorporates structural transparency.  
And this transparency doesn't increase management items but  
**appropriately disperses responsibilities, thereby reducing the operational burden**.

> Monolithic structures tend to hide problems,  
> MSA is a structure that reveals problems.

Problems must be revealed to be solved,  
and as such revelations repeat, the structure is refined in a more robust direction.

Thus, the perception that "MSA is uncomfortable" can be transformed in this way.

> **"MSA can feel uncomfortably transparent."**  
> But that transparency is precisely what  
> **ultimately creates a faster organization.**

---

## The Real Challenge Isn't the Structure

MSA is often evaluated as structurally difficult.  
But in reality, most technologies can be learned through documentation and examples,  
and necessary tools can also be used by adopting existing open-source or cloud services.

Structural design can also be sufficiently improved through repetitive feedback,  
and modularization is not such a difficult task once certain standards are set.

From my experience,  
the real challenge was **dealing with the transparency created by the structure**.

Transparent structures clearly reveal responsibilities,  
reduce ambiguity, and distinctly divide each person's role.  
In this process, individuals or teams  
face their decisions and outcomes more directly.

This encounter can sometimes feel uncomfortable,  
and the movement to avoid this discomfort can appear as structural resistance.

Thus, in the end,  
the real difficulty is not the technical difficulty or design complexity,  
but **the cultural tension and personal attitude changes revealed through the structure**.

---

## In Conclusion

MSA is not simply a technology that divides structures.  
Rather, it is a cultural change that clearly defines responsibilities, redefines the way of collaboration,  
and allows the organization to transparently face its own work.

This transparency may be uncomfortable, but  
when we overcome this discomfort,  
we can create a faster and healthier system.

MSA is not difficult.  
It's just that its transparency is unfamiliar and not yet comfortable.

---

## Attachment 1: Common Misunderstandings – Are Kubernetes, Compose, FaaS MSA?

I want to briefly organize a few common technical misunderstandings encountered in practice.  
It may help to reflect on how MSA's philosophy is interpreted and intertwined with the choice of tools.

Should we use Kubernetes?
Isn't Docker Compose enough?
Is FaaS also MSA?

These questions all result from a misunderstanding of MSA as a problem of choosing technical tools.
However, tools are merely a means of realization,
and the essence of MSA is not the tool but the philosophy.

MSA is not about how boundaries are divided but the attitude of accepting boundaries.

Below, we'll delve a little deeper into the relationship between tools and philosophy, centered around three common misunderstandings.

### 1. Does using Kubernetes make it MSA?
Kubernetes is an excellent tool.
It's a suitable platform for deploying multiple services, scaling, and managing their states.

So many teams think, "To do MSA, we must first adopt Kubernetes."
But the reality might be the opposite.

If you've adopted Kubernetes, but the boundaries between services are still vague,

deployments are still tied together in their entirety,

and operations are still managed centrally,

then it's just a monolithic using Kubernetes.

Kubernetes is a tool that can create conditions for realizing MSA,
not MSA itself.

Just because Kubernetes is introduced doesn't automatically divide team responsibilities,
organize contracts, or make the organization move autonomously.

Introducing tools first and understanding the philosophy later is structurally risky.

### 2. Is it not MSA if we use Docker Compose?
Conversely, some people say, "We still can't use Kubernetes, so MSA is out of our reach."
But is that really the case?

Actually, even in a Docker Compose environment, if the following conditions are met,
the philosophy of MSA can be fully realized.

Each service has an independent codebase and responsibility,

is loosely connected through APIs,

and deployments or experiments are performed on a service basis,

then even using technically simple tools,
you can create a structure close to MSA organizationally.

Compose is actually a good environment to start experimenting.

Dividing into small units, experiencing failures, and replacing components,
the Compose environment is sufficiently meaningful as a training ground for modular thinking.

The starting point of MSA is not necessarily Kubernetes, but a sense of boundaries.

### 3. Is it MSA if we use FaaS?
Another misunderstanding is,
"We use FaaS (Lambda, Cloud Function, etc.), so we have a microservice structure."

FaaS allows you to execute services in small, fast units,
and offers many advantages in terms of scaling and cost.
However, that doesn't mean it's MSA.

If you've created multiple Lambdas, but

functions are not disconnected and rely on sequential calls,

the call flow is difficult to track,

and responsibility and ownership are vague,

then it might just be finely chopped spaghetti.

FaaS is just an execution unit,
it doesn't provide answers on how to define domains and responsibilities, interfaces, or the scope of failures.

If the reason for using FaaS

is not to divide the system into smaller parts but

to reduce costs and deploy quickly,

then that structure can develop into a more complex and difficult-to-track form.

In conclusion,
tools cannot replace philosophy.
Tools can provide a basis for realizing philosophy,
but they cannot become philosophy themselves.

Whether you use Kubernetes or not, it's not MSA if the responsibilities are not divided.

Even in a Compose environment, if boundaries and responsibilities are clear, it's MSA.

Even if you use FaaS, if the call flow is tangled and responsibilities are unclear, it's not MSA.

MSA is not a problem of technology, but a matter of perspective.
MSA starts from the question of not how to divide the system,
but how people and responsibilities should be divided.

---

## Attachment 2: What It Means for a Startup to Aim for MSA

Aiming for MSA does not mean
"We have divided the structure from the start."

Rather, it means,
"We are working in a way that allows us to divide at any time."

Dividing the structure is a result,
and designing the way of work to make that result possible is the real starting point of MSA.

This includes the following attitudes:

1. **Recognize the workflow**
   - How requests are generated,
   - Who responds,
   - What decisions are made under which conditions are organized into a flow.

2. **Organize contracts**
   - Data structures, request conditions, failure handling, etc.
   - Forms of contracts that can be passed and automated are prepared.

3. **Work with templates**
   - Standardize the repeated request and response process,
   - Embed clear responsibilities and interfaces in the structure.

4. **Design language and structure before technology**
   - Define units of collaboration and document boundaries of roles and responsibilities before code.

### The Same Inquiry as Bureaucracy in the Industrial Age

Actually, this mindset is not new.
The fundamental principles of **bureaucracy established as organizations grew massively after industrialization** started from similar questions:

- Which function should handle this work?
- Who approves, who executes, and who is responsible?
- What procedures and documents ensure the flow?

Thus, **designing the roles, functions, powers, and responsibilities, procedures, and flows of an organization** has been a basic condition necessary for operating complex systems for a long time.

MSA is just expressing that in a software-centric way.
Therefore, when a startup aims for MSA,
it's not a declaration of "working like an enterprise,"
but a pragmatic choice to equip a structural language and flow that can withstand expansion.

### Building Together, What Needs to Be Prepared First

And this direction is not a matter of an individual developer's habits or technical choices but
**a way of working that the organization must build together**,
and it's a responsibility **leadership must first prepare and open up**.

In an organization where the leader has not prepared, asking for structure tends to leave execution to individuals and blur responsibilities.
If aiming for MSA, a **structural designer who first proposes that language, standards, and flow** is needed.

> Aiming for MSA in a startup means
> not just designing a system,
> but **designing a culture where the entire organization can grow together**.

MSA is not about grand structures,
but about the attitude of working together in a way that can be separated later.

---

## Attachment 3: Foundational Literature Review for MSA Design (Chronological Summary)

### 1. *Domain-Driven Design: Tackling Complexity in the Heart of Software* – Eric Evans (2003)

#### English Summary

This book introduces the concept of bounded context — a clearly defined boundary within which a particular domain model is valid. It emphasizes domain modeling, strategic design, and the importance of aligning software structure with business concepts. These ideas are foundational to defining microservice boundaries that map cleanly to business capabilities.

#### Contribution to MSA Design:

- Encourages services to be built around business domains.
- Promotes clear ownership, isolation, and internal consistency of models.
- Introduces the idea that each service has its own ubiquitous language within its context.

### 2. *Service-Oriented Architecture: Concepts, Technology, and Design* – Thomas Erl (2005)

#### English Summary

This book defines core SOA principles including service contract, autonomy, reusability, composability, and statelessness. It offers a technological and conceptual foundation for thinking in services, encouraging interoperability and abstraction from implementation details.

#### Contribution to MSA Design:

- Lays groundwork for service modularity and separation of concerns.
- Promotes loose coupling through standardized interfaces.
- Advocates service granularity and orchestration.

### 3. *SOA Manifesto* (2009)

#### English Summary

The manifesto outlines the philosophical stance of SOA, prioritizing business goals over technical implementation. It embraces flexibility, modularity, and contract standardization. These principles philosophically anticipate many of MSA’s later values.

#### Contribution to MSA Design:

- Frames service architecture as a response to business change.
- Values adaptability and governance over rigid implementation.
- Advocates contract-first design, later adopted in MSA APIs.

### 4. *Microservices* – James Lewis & Martin Fowler (2014)

#### English Summary

This influential article synthesizes industry practice into a clear set of microservice characteristics: decentralized governance, independent deployability, smart endpoints and dumb pipes, and organization-aligned architecture. It became the conceptual launchpad for MSA in practice.

#### Contribution to MSA Design:

- Defines microservices as independent, business-aligned units.
- Encourages teams to own the full lifecycle of services.
- Highlights operational concerns like deployment automation and observability.

### 5. *Microservices: A Systematic Mapping Study* – Pires & Pereira (2018)

#### English Summary

This paper surveys the academic landscape of microservices, classifying literature into categories like architecture, implementation, deployment, and monitoring. It presents challenges such as service granularity, data consistency, and orchestration vs. choreography.

#### Contribution to MSA Design:

- Offers taxonomy of MSA-related concerns in research.
- Highlights open challenges (e.g., how fine-grained is “too fine”?).
- Bridges gap between theory and real-world implementation.

### 6. *Microservices: Yesterday, Today, and Tomorrow* – Fritzsch et al. (2019)

#### English Summary

This historical review explores the evolution of service-based systems, analyzing how microservices emerged from SOA, component-based design, and agile delivery practices. It identifies common adoption patterns and anti-patterns from empirical studies.

#### Contribution to MSA Design:

- Tracks historical context that shaped MSA.
- Informs how organizations transitioned from monoliths.
- Describes pitfalls like over-fragmentation and distributed complexity.

### Summary Insights for Practical Design

| Year | Work | Core Concept | Design Insight |
|------|------|---------------|----------------|
| 2003 | DDD | Bounded Context | Split services by domain boundaries |
| 2005 | SOA | Reusability, Autonomy | Modular thinking and abstraction in service boundaries |
| 2009 | SOA Manifesto | Agility, Contract-first | APIs must follow explicit service contracts |
| 2014 | Lewis & Fowler | Independent Deployment, Ownership | Encourage team-level service responsibility |
| 2018 | Mapping Study | Research Taxonomy | Provide structured understanding for real-world implementation |
| 2019 | Historical Review | Evolution, Anti-patterns | Warn against over-fragmentation and complexity in practice |

---

## Revision History

- 2025-07-01: Added Attachment 3: Foundational Literature Review for MSA Design (Chronological Summary)”
- 2025-06-30: 'Attachment 2: What It Means for a Startup to Aim for MSA' section added
- 2025-06-30: 'Attachment 1: Common Misunderstandings – Are Kubernetes, Compose, FaaS MSA?' section added
- 2025-06-30: 'Increased Communication Costs' section added
- 2025-06-30: “Services should be bounded based on responsibility” sentence enhanced
- 2025-06-30: Initial post