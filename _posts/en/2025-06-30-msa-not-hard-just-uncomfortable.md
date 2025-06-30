---
date: 2025-06-30
layout: post
permalink: /en/2025/06/30/msa-not-hard-just-uncomfortable.html
summary: MSA는 기술적으로 어려운 것이 아니라, 구조 안에서 책임을 받아들이는 일이 불편하기 때문에 어렵게 느껴진다고 생각합니다. 이 글은
  MSA를 직접 실행하며 얻은 경험과 해석을 바탕으로 그 본질을 다시 정리합니다.
tags:
- Design Philosophy
- Organizational Culture
title: MSA Doesn't Increase Costs; It's Just Inconvenient.
---

> `gpt-4-turbo` has translated this article into English.

---

## Preface

Many people talk about MSA.  
They say to separate services and emphasize clear contracts.  
Advice on dividing responsibilities and localizing failures is also common.

However, as these discussions continue,  
it becomes apparent that many have not actually implemented such structures.

This article organizes some small insights and interpretations gained through structuring and operating MSA firsthand,  
forming actual teams, experiencing failures, and through the process of separating and reintegrating systems.

The perception that MSA is difficult,  
the argument that initial adoption costs are high,  
and the concern that it burdens the organization.

I aim to calmly examine where these claims come from,  
and what fears and avoidance are hidden behind them, from the perspective of an experienced practitioner.

> **MSA is not difficult. It's just inconvenient because it's overly transparent.**

---

## Is MSA Really Difficult?

Many organizations hesitate to adopt MSA.  
You often hear that "it's costly," "the structure is complex," "it's not suitable for early startups."

But looking back at my experiences,  
it seems that these judgments were not solely due to the structural limitations of MSA.

From what I observed,  
- A culture where responsibilities are not clearly divided,
- Unclear contractual relationships,
- Code structures that easily hide problems,
- An atmosphere that resists experimentation  
often led to higher costs.

> **The perception that MSA is costly might be due to its transparency.**  
> Previously unseen inefficiencies might have been revealed.

If we had started with a modular structure from the beginning,  
small failures could have been easily fixed, and  
new attempts could have been made without much burden.

Ultimately, the problem was closer to the attitude and mindset of accepting the transparency revealed by the structure, rather than the structure itself.

---

## Fearless Because We Started with Modules

It's difficult to design a perfect structure from the start.  
However, a deletable structure, a design with separated boundaries,  
and the mindset that it can always be recreated were sufficiently achievable.

In the initial development phase, we chose to divide functionalities into modular units.  
We separated each function into independent files and tried to keep execution units small.  
As a result, we could respond by replacing or removing only the problematic module without discarding the entire system.

This approach enabled a structure where we could be less afraid of failures.  
- Refactoring was freely performed,
- A/B testing could be attempted relatively freely,
- The scope of responsibility in the code became clearer,
- The structure was gradually refined through repetitive experimentation.

The starting point of these results was 'modular thinking'.

In fact, the thought process of dividing into modules was not special.  
Windows OS's DLL, Java's class loader, Python's `importlib` were also following the same principle long before.  
About 15 years ago, a module loader I personally implemented was also part of this flow.

> **A dynamically loadable structure** means more than just technical convenience.  
> It was an approach that allowed for failure, providing structural leeway.

MSA was not initially based on a grand framework either.  
It started from a somewhat old but flexible method,  
and I felt that it ultimately secured more elasticity at a lower cost.

---

## It's Not the Technology, It's the Attitude That's Hard

Some people say MSA is difficult.  
API gateways, inter-service authentication, message brokers, CI/CD, container orchestration, etc.,  
there are many technological elements to learn.

Certainly, there is a lot to learn.  
But over time, I realized that  
these technologies have well-organized documents, examples, and active communities.  
Ultimately, they are areas that can be learned with time.

What's harder is not the technology, but the **attitude**.

MSA is technically a structure, but  
first and foremost, it presupposes an **attitude of distributing responsibilities, respecting boundaries, and adhering to contracts**.  
And this responsibility involves discomfort.

- If responsibilities are clear, avoidance becomes difficult.
- If interfaces are organized, there's less room for excuses.
- If a monitoring system is in place, the phrase "I didn't know" loses its persuasiveness.

The reason MSA feels difficult is not so much the technical difficulty of the technology itself but  
**because it confronts the attitude required by its structure**.

> **The structure is a device that reveals responsibility, and MSA does not hide it.**

---

## What's Needed Is Not Technology, But the Recognition of Its Necessity

Dividing the structure itself is not difficult.  
Designing APIs, separating services, and deploying with containers are  
tasks that a skilled developer can sufficiently perform.

However, continuously operating, maintaining, and making the structure scalable  
cannot be achieved by technology alone.  
At its core, there was **culture**.

MSA asks people through its structure:
- Do you know what your responsibilities are?
- Are you calling services that don't need to be called?
- When the contract changes, who should you communicate with and how?

Ultimately, MSA is not just about the introduction of technology or structural design,  
but about **dividing responsibilities, moving based on trust, and training autonomy in a cultural** problem.

If the structure is introduced without forming this culture,  
MSA could instead induce greater complexity,  
make it difficult to identify the causes of problems,  
and increase fatigue within the team.

Therefore, what's important is not just the introduction of technology but  
understanding why the structure is necessary and  
creating a cultural recognition that can be shared by everyone.

> **MSA is a process of agreeing on how to live together before structural design.**  
> Within that, people learn responsibilities, repeat collaboration, and build trust.

---

## The Real Reason Communication Costs Increase

MSA was originally proposed as a structure to reduce communication costs.
Each service has clear boundaries, and teams autonomously take responsibility,
enabling independent development and deployment without unnecessary coordination.

However, in reality,  
I often hear that communication costs have increased instead.

Why is that?

I think there are two reasons.

### 1. Because boundaries were divided based on functionality, not responsibility

In many cases, service boundaries are divided based on the following criteria:

- Separate it because it has a lot of traffic
- Make authentication a common feature module
- Separate the API as the front and back are separated

However, these criteria are units of 'function,' not 'responsibility.'
As a result, when a failure or change occurs,
questions like "Who is responsible for this?" cannot be clearly answered.

> **Services should be bounded based on responsibility.**  
> Functional separation is a helpful means, not a standard for dividing responsibility.

- Services are divided,
- Responsibilities are blurred,
- Call flows overlap,

and inter-service consultations actually increase.

Ultimately, a service structure with improperly drawn boundaries can
not only fail to reduce communication costs but may also cause them to skyrocket.

### 2. Because the purpose of 'why divide' was forgotten

MSA was meant not to "divide small," but to "enable independent movement."

However, if this purpose becomes vague during implementation,
only a structure of 'lined up small services' remains.

- Small but strongly intertwined services
- A structure where multiple teams have to coordinate even for small changes
- Testing and deployment are not independent, instead, the sequence becomes difficult to align

These results appear when obsessed with the word "Micro"
and losing sight of "why divide."

Ultimately, the experiences of increased communication costs indicate not a failure of the structure but that **responsibility and purpose were not considered together in establishing the structure**.

---

## Education is an Inevitable Cost

Discussions related to the introduction of MSA often include the same concerns,
namely that "the cost of education is too high."

Changing structures requires retraining the team,
people's mindsets need to change,
and familiar tools must be replaced with new ones, which can be burdensome.

These concerns are entirely understandable.
However, it's worth asking one question.

> **Really, was the monolithic system operated without any training?**

In reality, I think not.
Monolithic systems also operated on many informal educations such as:

- Unwritten rules,
- Information passed orally,
- Undocumented dependencies,
- Unclear division of responsibilities

This method might not have been visible,
but it continuously consumed **time and energy** through developers' explanations, newcomers' implicit guesses, and repetitive questions and answers.

It's just that the cost was not structurally visible,
but it has always been there.

MSA attempts to **formalize, document, and systematize** this learning cost.
Thus, while the cost is visible,
it's not a new burden but **a clarification of previously hidden costs**.

Furthermore, such costs will inevitably occur at some point.
Therefore, rather than hastily starting education at the point of structural transition,
**starting from a structure that presupposes education from the beginning** can be a more stable and sustainable choice.

> **Education is an inevitable cost.**  
> It's just a matter of whether to delay it,
> or to include it in the structure from the beginning.

---

## A Transparent Structure is a Fast Structure

MSA can often feel inconvenient.
Responsibilities are clearly exposed, boundaries are fixed, and dependencies are starkly revealed within the structure.
These characteristics can be burdensome.

However, paradoxically, this transparency
enables **faster decision-making and execution** as I have experienced.

When the structure is transparent, there are fewer opportunities to evade:
- Bottlenecks can be quickly identified,
- Points of delayed response can be easily tracked,
- Broken contracts are clearly exposed.

In such a structure,
- The number of communications decreases,
- The time spent in consultation shortens,
- Decision-making naturally disperses.

MSA inherently includes structural transparency.
And this transparency does not increase management items but
**appropriately distributes responsibilities, thereby reducing operational burdens**.

> Monolithic structures tend to hide problems,
> MSA exposes them.

Problems must be exposed to be solved,
and as such exposure repeats, the structure is refined towards greater robustness.

Thus, the perception that "MSA is inconvenient" can be transformed in this way.

> **"MSA may feel inconvenient because it's overly transparent."**  
> However, that transparency is the foundation for
> **ultimately creating a faster organization.**

---

## Really, the Structure is Not the Difficult Part

MSA is often evaluated as structurally difficult.
But in reality, most technologies can be learned through documents and examples,
and the necessary tools can also be used by adopting existing open-source or cloud services.

Structural design can also be sufficiently improved through repetitive feedback,
and modularization is not that difficult once certain standards are set.

From my experience,
the real difficult point was **managing the transparency created by the structure**.

Transparent structures clearly expose responsibilities,
reduce ambiguities, and distinctly divide each person's role.
In this process, individuals or teams
face their decisions and outcomes more directly.

This encounter can sometimes feel uncomfortable,
and the movement to avoid this discomfort can appear as structural resistance.

Thus, ultimately,
the real difficulty is not the technical difficulty or design complexity, but
**the cultural tension and personal attitude changes revealed through the structure**.

---

## In Conclusion

MSA is not simply a technology that divides structures.
Rather, it clarifies responsibilities, redefines ways of collaboration,
and allows the organization to transparently face its own work, fostering cultural change.

This transparency may be uncomfortable, but
when we overcome this discomfort,
we can build a faster and healthier system.

MSA is not difficult.
It's just that its transparency is unfamiliar and not yet comfortable.

---

## Appendix 1: Common Misunderstandings – Are Kubernetes, Compose, and FaaS MSA?

I want to briefly clarify a few technical misunderstandings often encountered in practice.
It might help to reflect on how the philosophy of MSA is interpreted and intertwined with tool choices.

Should we use Kubernetes?
Is Docker Compose not enough?
Is FaaS also MSA?

These questions all result from misunderstanding MSA as a matter of choosing technical tools.
However, tools are merely means of realization,
and the essence of MSA is not the tools but the philosophy.

MSA is not about how boundaries are divided, but how boundaries are accepted.

Below, I will delve a bit more into the relationship between tools and philosophy centered around three common misunderstandings.

### 1. Does using Kubernetes mean implementing MSA?
Kubernetes is a great tool.
It's a suitable platform for deploying multiple services, scaling them, and managing their state.

Therefore, many teams think, "To do MSA, we must first introduce Kubernetes."
However, the reality might be the opposite.

If you've introduced Kubernetes, but the boundaries between services are still vague,

deployments are still tied together in their entirety,

and operations are still managed centrally,

then it's just a monolithic using Kubernetes.

Kubernetes can provide the conditions to realize MSA,
but it is not MSA itself.

Just because you've introduced Kubernetes does not mean
the team's responsibilities are divided,
contracts are organized, or
the organization moves autonomously.

Introducing tools first and understanding philosophy later is structurally risky.

### 2. Is it not MSA if you use Docker Compose?
Conversely, some people say, "We can't use Kubernetes yet, so MSA is out of reach."
But is that really the case?

Actually, even in a Docker Compose environment, if the following conditions are met,
the philosophy of MSA can be fully realized:

Each service has an independent codebase and responsibilities,

they are loosely connected through APIs,

and deployments or experiments are conducted at the service level,

then, even if the technical tools are simple,
organizationally, a structure close to MSA can be created.

Compose is rather a good environment to start experiments.

Dividing into small units, experiencing failures, and making replacements,
as a training ground for modular thinking, the Compose environment is sufficiently meaningful.

The starting point of MSA is not necessarily Kubernetes, but a sense of boundaries.

### 3. Is it MSA if you use FaaS?
Another misunderstanding is,
"We use FaaS (Lambda, Cloud Function, etc.), so our structure is microservices."

FaaS allows services to run in small, fast units and offers many advantages in terms of scaling and cost.
However, that does not mean it is MSA.

If you've created several Lambdas, but

functions are not disconnected and rely on sequential calls,

it's hard to understand the call flow,

and responsibility and ownership are vague,

then it's just finely chopped spaghetti.

FaaS is a unit of execution, not a solution for defining domains, responsibilities, interfaces, and the scope of failures.

If the reason for using FaaS is

not to divide the system into smaller parts, but

to reduce costs and deploy quickly,

then the structure might develop into a more complex and difficult-to-track form.

In Conclusion
Tools cannot replace philosophy.
Tools can provide a foundation for realizing philosophy,
but they cannot become philosophy themselves.

Even if you use Kubernetes, it's not MSA if responsibilities are not divided.

Even in a Compose environment, it's MSA if boundaries and responsibilities are clear.

Even if you use FaaS, it's not MSA if the call flow is tangled and responsibilities are unclear.

MSA is not a problem of technology, but a matter of perspective.
MSA starts with the question of how systems should be divided,
not how people and responsibilities should be divided.

---

## Appendix 2: What It Means for a Startup to Work Towards MSA

If a startup says it is aiming for MSA,
that statement means "we work in a way that can be divided," not just "we divided the structure from the start."

This includes the following attitudes:

1. **Recognizing the workflow**  
   - How requests are generated,
   - Who responds,
   - What decisions are made under what conditions, are organized into a flow.

2. **Organizing contracts**  
   - Data structures, request conditions, failure handling, etc.,
   - Forms of contracts that can be passed on and automated are prepared.

3. **Working while creating templates**  
   - Standardizing repeated request and response processes,
   - Embedding clear responsibilities and interfaces within the structure.

4. **Designing language and structure before technology**  
   - Defining units of collaboration before code,
   - Documenting boundaries and responsibilities.

### The Same Question as the Bureaucracy of the Industrial Age

In fact, this way of thinking is not new.
The basic principles of **bureaucracy established as organizations grew massively after industrialization** also started from similar questions:

- Which function should handle this task?
- Who approves, who executes, and who is responsible?
- What procedures and documents guarantee the flow?

Thus, **designing the roles and functions, authority and responsibilities, procedures and flow of an organization** has been a basic condition necessary for operating complex systems for a long time.

MSA is just a **software-centric expression** of that.
Therefore, when a startup aims for MSA,
it's not declaring to work like an enterprise, but rather making a pragmatic choice to have a structural language and flow that can withstand expansion.

### Together and What Needs to Be Prepared First

And this direction is not a matter of individual developers' habits or technological choices,
but a way of working that the **organization must create together**,
and a responsibility that **leadership must prepare and open first**.

If the organization asks for structure without the leader's preparation,
responsibility is delegated to the individual and becomes blurred.
If aiming for MSA, a **structural designer who first proposes that language, standards, and flow** is needed.

> When a startup says it aims for MSA,
> it's not just about designing a system,
> but about designing a culture where **the entire organization can grow together**.

MSA is not about grand structures,
but about an attitude of working together in a way that can be separated later.