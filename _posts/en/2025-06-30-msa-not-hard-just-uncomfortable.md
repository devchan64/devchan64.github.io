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

## Introduction

Many people talk about MSA.  
They tell you to separate services and emphasize clear contracts.  
Advice on dividing responsibilities and localizing failures is also common.

However, as these discussions continue,  
it becomes apparent that not a few have never actually implemented such a structure.

This article organizes some small insights and interpretations gained through structuring and operating MSA directly,  
forming actual teams, experiencing failures, and through the process of separating and reintegrating systems.

The perception that MSA is difficult,  
the argument that initial adoption costs are high,  
and the concern that it is a burden on the organization.

I would like to calmly examine where these claims come from,  
and what fears and avoidance are hidden behind them, from the perspective of an experienced person.

> **MSA is not difficult. It's just uncomfortably transparent.**

---

## Is MSA Really Difficult?

Many organizations hesitate to adopt MSA.  
You often hear that "it is costly," "the structure is complex," and "it is not suitable for startups."

However, looking back on the cases I have experienced,  
it seems that these judgments did not solely arise from the structural limitations of MSA.

From what I have observed,  
- a culture where responsibilities are not clearly divided,  
- unclear contractual relationships,  
- code structures that easily hide problems,  
- a decision-making atmosphere that is averse to experimentation,  
were often causing more costs.

> **The perception that MSA is costly might be because of its transparency.**  
> It might be the result of inefficiencies that were previously invisible coming to light.

If we had started with a modular structure from the beginning,  
small failures could have been easily fixed, and  
new attempts could have been made repeatedly without much burden.

Ultimately, the issue was closer to the attitude and approach towards the transparency revealed by the structure than the structure itself.

---

## It Wasn't Scary Because We Started with Modules

It's difficult to design a perfect structure from the beginning.  
However, a deletable structure, a design with separated boundaries,  
and the mindset that it can always be rebuilt were sufficiently achievable.

In the initial development phase, we chose to divide functions into module units.  
We tried to keep each function in separate files and the execution units small.  
As a result, we could respond by replacing or removing only the problematic modules without discarding the whole system.

This approach ultimately made a structure where we need not fear failure too much possible.  
- Refactoring was freely performed,  
- A/B testing was relatively stress-free,  
- The scope of responsibility in the code gradually became clearer,  
- and the structure was slowly refined through repetitive experimentation.

At the starting point of these results was ‘modular thinking.’

In fact, the mindset of dividing into module units wasn't anything special.  
The DLL of the Windows operating system, Java’s classloader, Python’s `importlib`  
were also following the same principle, having existed long before.  
About 15 years ago, a module loader I personally implemented was also part of this trend.

> **A dynamically loadable structure** does not just mean technical convenience.  
> It was an approach that allowed failure, providing structural leeway.

MSA also did not start based on a grand framework.  
It started with somewhat outdated but flexible methods,  
and ultimately, I felt that it secured higher resilience with lower costs.

---

## Attitude, Not Technology, Is the Hard Part

There are often people who say MSA is difficult.  
API gateways, inter-service authentication, message brokers, CI/CD, container orchestration, etc.,  
there are many technological elements to learn.

It is true that there is a lot to learn.  
But over time, you realize that these technologies have well-organized documentation, examples, and active communities.  
Ultimately, they are areas that can be mastered with time.

What is more difficult than technology is **attitude**.

MSA is a technological structure, but  
it first presupposes an attitude of **distributing responsibilities, respecting boundaries, and adhering to contracts**.  
And these responsibilities come with discomfort.

- Clear responsibilities make it hard to evade.  
- Organized interfaces reduce excuses.  
- A structured monitoring system makes "I didn’t know" a less convincing excuse.

The reason MSA feels difficult is not so much because of the technical difficulty of the technology itself,  
but because **it confronts the attitude required by that structure**.

> **Structure is a device that reveals responsibility, and MSA does not hide it.**

---

## What We Need Is Not Technology, But the Recognition of Its Necessity

Dividing structures themselves is not difficult.  
Designing APIs, separating services, and deploying with containers  
are all within the capabilities of a skilled developer.

However, continuously operating, maintaining, and making the structure scalable  
cannot be achieved by technology alone.  
At its core lay **culture**.

MSA asks people through the structure:  
- Do you know what your responsibilities are?  
- Are you calling services that you shouldn’t need to?  
- When contracts change, who and how will you communicate?

Ultimately, MSA is not just a problem of technology adoption or structural design,  
but a problem of **a culture that divides responsibilities, moves based on trust, and trains autonomy**.

If the structure is introduced without this culture being formed,  
MSA may instead induce greater complexity,  
make it difficult to identify the cause of problems,  
and increase fatigue within the team.

Therefore, what is important is not so much the introduction of technology itself,  
but understanding why the structure is necessary and  
cultivating a cultural recognition that everyone can share.

> **MSA is a process of agreeing on how to live together before designing a structure.**  
> Within it, people learn responsibilities, repeat collaboration, and build trust.

---

## The Real Reason Communication Costs Increase

MSA was originally proposed as a structure to reduce communication costs.  
Each service has clear boundaries, teams autonomously take responsibility, and  
it allows independent development and deployment without unnecessary consultation.

However, in reality,  
you often hear that communication costs have actually increased.

Why is that?

I think there are two reasons.

### 1. Because Boundaries Were Divided Based on Function, Not Responsibility
In many cases, service boundaries are divided based on the following criteria:

- Separate it because it has a lot of traffic
- Make authentication a module because it’s a common function
- Separate the API like front and back are divided

However, these criteria are based on 'function' units, not 'responsibility' units.
As a result, when a failure or change occurs,
a clear answer to the question “Who is responsible for this?” is not available.

> **Services should have boundaries set based on responsibility.**  
> Functional separation is a helping tool, not a criterion for dividing responsibilities.

- Services are divided,
- but responsibilities blur,
- and call flows overlap,

and inter-service consultations actually increase.

In the end, a service structure with improperly drawn boundaries
can explode communication costs instead of reducing them.

### 2. Because the Purpose of 'Why Divide' Was Forgotten
MSA's goal is not **'to divide small,'** but  
**'to enable independent movement.'**

However, if this purpose becomes vague during implementation,
only a structure of 'small services lined up' remains.

- Small but strongly intertwined services
- A structure where multiple teams must coordinate even for small changes
- Testing and deployment are not independent, but rather the sequence is difficult to match

These results appear when you obsess over the word "Micro" and
lose sight of "why to divide."

Eventually, the experience that communication costs have increased is not because the structure has failed,  
but because responsibility and purpose were not considered together in establishing the structure.

---

## Education Is an Inevitable Cost

The same concern often appears in discussions related to MSA adoption.  
Specifically, the claim that “education costs are too high.”

Changing structures requires re-educating the team,  
a change in people’s mindsets is necessary, and  
familiar tools need to be replaced with new ones, which can feel burdensome.

This concern is completely understandable.  
However, there is a question that needs to be asked.

> **Really, was the monolithic system operated without any training?**

I believe that was not the case.  
The monolithic system was also operated presupposing many informal educations, such as:

- Unwritten rules,
- Orally transmitted information,
- Undocumented dependencies,
- Unclear responsibility distinctions

This method may not have been visible to the eye, but  
developers explaining to each other, newbies making implicit guesses, and repetitive questions and answers  
continuously **consumed time and energy**.

Just that the cost was not structurally visible,  
but it has actually been continuously present.

MSA attempts to **formalize, document, and systematize** these learning costs.  
So, while it appears costly,  
it is not a new burden but rather **a clarification of previously hidden costs**.

Moreover, such costs will inevitably occur at some point.  
Therefore, rather than starting education hurriedly at the point of transitioning structure,  
**starting on a structure that presupposes education from the beginning**  
can be a more stable and sustainable choice.

> **Education is an inevitable cost.**  
> It's just a matter of whether to delay it,  
> or include it in the structure from the beginning.

---

## A Transparent Structure Is a Fast Structure

MSA often feels uncomfortable.  
Responsibilities are clearly revealed, boundaries are fixed, and dependencies are starkly exposed within the structure.  
These characteristics can act as a burden.

However, paradoxically, this transparency  
enables **faster decision-making and implementation**, as I have experienced.

With a transparent structure, there is less room for evasion.  
- You can quickly identify where bottlenecks occur,
- Easily trace points of delayed response,
- And clearly see where contracts are broken.

In such a structure,
- The number of communications is reduced,
- The time spent in consultation is shortened, and
- Decision-making naturally becomes decentralized.

MSA inherently includes structural transparency.  
And this transparency does not increase management items but  
**appropriately distributes responsibilities, thereby reducing the operational burden.**

> Monolithic structures tend to hide problems,  
> while MSA reveals them.

Problems can be solved only when they are revealed,  
and as such revelation is repeated, the structure is refined in a direction that becomes increasingly robust.

Thus, the perception that “MSA is uncomfortable” can be transformed like this.

> **"MSA may feel uncomfortable because it’s excessively transparent."**  
> However, that transparency is precisely what  
> **ultimately builds a faster organization.**

---

## The Real Difficulty Isn't the Structure

MSA is often evaluated as structurally difficult.  
However, in reality, most technologies can be learned through documentation and examples,  
and necessary tools can also be utilized by adopting existing open-source or cloud services.

Structural design can also be sufficiently improved through repetitive feedback,  
and modularization is not a difficult task once certain standards are set.

From my experience,  
the real difficult point was **dealing with the transparency created by the structure.**

A transparent structure clearly reveals responsibilities,  
reduces ambiguity, and distinctly divides each person’s role.  
In this process, individuals or teams  
face their decisions and results more directly.

This encounter can sometimes feel uncomfortable,  
and the movement to avoid this discomfort can appear as structural resistance.

Thus, ultimately,  
the real difficulty is not the technical difficulty or design complexity,  
but **the cultural tension and change in personal attitudes revealed through the structure.**

---

## In Conclusion

MSA is not simply a technology that divides structures.  
Rather, it is a cultural change that clarifies responsibilities, redefines ways of collaboration,  
and allows organizations to transparently face their own work.

This transparency may be uncomfortable,  
but when we overcome this discomfort,  
we can build a faster and healthier system.

MSA is not difficult.  
It's just that its transparency is unfamiliar and not yet comfortable.

---

## Common Misconceptions – Are Kubernetes, Compose, FaaS MSA?

I would like to briefly address a few common technical misunderstandings encountered in practice.  
It may help to reflect on how the philosophy of MSA is interpreted and intertwined with tool choices.

Do you need to use Kubernetes?
Is Docker Compose insufficient?
Is FaaS also MSA?

These questions all result from misunderstanding MSA as a choice of technical tools.
However, tools are merely a means of realization,
and the essence of MSA is not the tools but the philosophy.

MSA is not about how to divide boundaries, but an attitude of accepting boundaries.

Below, we will delve a bit deeper into the relationship between tools and philosophy centered around three common misconceptions.

### 1. Does using Kubernetes make it MSA?
Kubernetes is an excellent tool.
It is a suitable platform for deploying multiple services, scaling them, and managing their state.

Therefore, many teams think, “To do MSA, we must first introduce Kubernetes.”
However, the reality might be the opposite.

If you've adopted Kubernetes, but the boundaries between services are still vague,

deployments are still tied together as a whole,

and operations are still managed centrally,

then it's just a monolithic using Kubernetes.

Kubernetes is a tool that can create conditions to realize MSA,
but it is not MSA itself.

Just because you've introduced Kubernetes doesn’t automatically mean that
team responsibilities are divided or
contracts are organized or
the organization moves autonomously.

Introducing tools first and understanding the philosophy later is structurally risky.

### 2. Is it not MSA if you use Docker Compose?
Conversely, some say, “We still can’t use Kubernetes, so MSA is out of reach.”
But is that really the case?

In fact, even in a Docker Compose environment, if the following conditions are met,
the philosophy of MSA can be fully realized.

Each service has an independent codebase and responsibilities and

is loosely connected through APIs and

deployment or experiments are performed on a service basis,

then, even if you use technically simple tools,
you can create a structure close to MSA organizationally.

Compose is actually a good environment to start experiments.

Dividing into small units, trying and replacing failures,
Compose environment is sufficiently meaningful as a training ground for modular thinking.

The starting point of MSA is not necessarily Kubernetes, but a sense of boundaries.

### 3. Is it MSA if you use FaaS?
Another misconception is,
“We use FaaS (Lambda, Cloud Function, etc.), so we have a microservices structure.”

FaaS allows you to execute services in small, fast units and
offers many advantages in scaling and cost aspects.
However, that doesn’t mean it is MSA.

If you have created several Lambdas, but

functions are not disconnected and rely on sequential calls and

the calling flow is difficult to understand and

responsibility and ownership are vague,

then it’s just finely chopped spaghetti.

FaaS is just an execution unit,
it doesn’t provide answers on how to define domains and responsibilities, interfaces, and failure scopes.

If the reason for using FaaS is

not to divide the system into smaller parts but

to reduce costs and deploy quickly,

then that structure might develop into a more complex and difficult-to-track form.

In conclusion,
tools cannot replace philosophy.
Tools can be a basis that can realize philosophy,
but they cannot become the philosophy itself.

Using Kubernetes doesn’t make it MSA if responsibilities are not divided.

Even if it's a Compose environment, it's MSA if boundaries and responsibilities are clear.

Even if you use FaaS, if the calling flow is entangled and responsibilities are unclear, it's not MSA.

MSA is not a matter of technology, but a matter of perspective.
MSA starts with the question of how systems should be divided,
but really, how people and responsibilities should be divided.

---

## Revision

- 2025-06-30: `Common Misconceptions – Are Kubernetes, Compose, FaaS MSA?` section added
- 2025-06-30: ‘Increase in Communication Costs’ section added
- 2025-06-30: “Services should have boundaries set based on responsibility” sentence enhanced
- 2025-06-30: First posted