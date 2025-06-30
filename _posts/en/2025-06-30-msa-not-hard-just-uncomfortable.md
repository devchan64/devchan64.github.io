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
They tell you to separate services and emphasize making contracts clear.  
Advice on dividing responsibilities and localizing faults is also common.

However, as these discussions continue,  
you'll find that not infrequently, there are many who haven't actually implemented such structures.

This article organizes some small insights and interpretations gained through directly structuring and operating MSA,  
forming real teams, experiencing failures, and through the process of separating and re-integrating systems.

The perception that MSA is difficult,  
the argument that initial adoption costs are high,  
and the concern that it burdens the organization.

Where these claims come from,  
and what fears and avoidance lie beneath them  
will be calmly examined from the perspective of an experienced practitioner.

> **MSA is not difficult. It's just uncomfortably transparent.**

---

## Is MSA Really That Difficult?

Many organizations hesitate to adopt MSA.  
"It costs a lot," "the structure is complex," "it's not suitable for early startups," are common concerns.

However, looking back at the cases I've experienced,  
it seems that these judgments did not solely arise from the structural limitations of MSA itself.

From what I've observed,  
- A culture where responsibilities are not clearly divided,  
- Unclear contractual relationships,  
- Code structures that easily hide problems,  
- A decision-making atmosphere that shuns experimentation,  
often caused more costs.

> **The feeling that MSA is costly may be because the structure is transparent.**  
> Previously unseen inefficiencies may now be revealed.

If a modular structure had been considered from the beginning,  
small failures could have been easily fixed,  
and new attempts could have been made repeatedly without burden.

Ultimately, the issue was closer to the attitude and mindset toward accepting the transparency revealed by the structure, rather than the structure itself.

---

## Starting with Modules Was Not Scary

Designing a perfect structure from the beginning is difficult.  
However, a deletable structure, a design with separated boundaries,  
and a mindset that it can always be remade were sufficiently achievable.

In the initial development stage, we chose to divide functionality into modular units.  
We separated each function into independent files and tried to keep the execution units small.  
As a result, we could respond by replacing or removing only the problematic module without discarding the entire system.

This approach ultimately made a structure where failure was not greatly feared.  
- Refactoring was freely performed,  
- A/B testing could be carried out with relatively little burden,  
- The scope of responsibilities in the code became clearer,  
- The structure was gradually refined through repetitive experiments.

The starting point of these results was 'modular thinking.'

In fact, the mindset of dividing into modules was not something special.  
Windows operating system's DLLs, Java's class loaders, Python's `importlib`, and others  
had been following the same principle for a long time.  
I believe that the module loader I implemented personally about 15 years ago was also part of this trend.

> **A dynamically loadable structure** signifies not just a technical convenience.  
> It was an approach that allowed for failure, providing structural leeway.

MSA did not begin with a grand framework either.  
It started from a somewhat outdated but flexible method, and  
ultimately, I felt it allowed for securing higher resilience at lower costs.

---

## It's Not the Technology, It's the Attitude That's Hard

People often say MSA is difficult.  
API gateways, inter-service authentication, message brokers, CI/CD, container orchestration, etc.  
There are many technical elements to learn.

Of course, there's a lot to learn.  
But over time, you realize that  
these technologies have well-organized documentation, examples, and active communities.  
Ultimately, these are areas you can master with time.

What's more difficult is not the technology but **the attitude**.

MSA is technically a structure, but  
it primarily presupposes an attitude of **distributing responsibilities, respecting boundaries, and adhering to contracts**.  
And this responsibility involves discomfort.

- When responsibilities are clear, it's hard to evade them.  
- When interfaces are sorted, excuses diminish.  
- When a monitoring system is in place, the phrase "I didn't know" loses its persuasiveness.

The reason MSA feels difficult is not so much the technical difficulty,  
but because **it confronts the attitude required by its structure**.

> **The structure is a device that reveals responsibilities, and MSA does not hide them.**

---

## What's Needed Is Not the Technology, but the Recognition of Its Necessity

Structurally dividing tasks is not difficult.  
Designing APIs, separating services, and deploying with containers are  
tasks that a skilled developer can adequately perform.

However, continuously operating, maintaining, and making the structure scalable  
is not achieved by technology alone.  
**Culture** was at the core of this process.

MSA asks people through its structure:  
- Do you know what your responsibilities are?  
- Are you calling services that don't need to be called?  
- When a contract changes, who and how should you communicate?

Ultimately, MSA is not just about technology adoption or structural design,  
but about **a culture that divides responsibilities, moves based on trust, and trains autonomy**.

If this culture is not formed while only the structure is adopted,  
MSA can instead induce greater complexity,  
make it difficult to identify problems,  
and increase fatigue within the team.

Hence, what's important is not just the adoption of technology, but  
understanding why the structure is necessary and  
cultivating a cultural perception that everyone can share.

> **MSA is a process of agreeing on a way to live together before designing the structure.**  
> Within this, people learn responsibilities, repeat collaboration, and build trust.

---

## The Real Reason Communication Costs Increase

MSA was originally proposed as a structure to reduce communication costs.  
It envisioned services with clear boundaries, teams autonomously taking responsibility,  
and developing and deploying independently without unnecessary consultations.

However, in reality,  
there is often feedback that communication costs have increased instead.

Why is that?

I think there are two reasons for this.

### 1. Boundaries were divided based on function, not responsibility
Often, service boundaries are divided based on criteria like:

- Separate it because it has a lot of traffic
- Make authentication a module since it's a common function
- Divide APIs like we do front and back ends

However, these criteria are based on 'function' units, not 'responsibility' units.
As a result, when actual faults or changes occur,
the question "Who is responsible for this?" remains unclear.

> **Services should have boundaries established based on responsibility.**  
> Functional separation is a helpful means but should not be the criteria for dividing responsibilities.

- Services are divided,  
- Responsibilities become blurred,  
- Call flows overlap,

and inter-service consultations actually increase.

In the end, a service structure with incorrectly drawn boundaries can
not only fail to reduce communication costs but can skyrocket them.

### 2. The purpose of 'why divide' was forgotten
MSA's purpose was not **'dividing small'** but,  
**'making it possible to move independently'**.

But if this purpose becomes vague during implementation,  
only a structure with 'small services lined up' remains.

- Small but strongly intertwined services
- Structures where several teams need to coordinate even for small changes
- Tests and deployments are not independent but are difficult to sequence

These results appear when you fixate on the word "Micro" and  
lose sight of "why you're dividing."

The experience that communication costs have increased is not because the structure failed, but because **responsibility and purpose were not considered together in establishing the structure**.

---

## Education Is an Inevitable Cost

In discussions related to the adoption of MSA, the same concern often arises.  
That is the argument that "education costs are too high."

Changing structures requires retraining teams,  
people need to change their ways of thinking, and  
there's a burden of having to learn new tools instead of the familiar ones.

This concern is completely understandable.  
However, one question needs to be asked.

> **Really, was the monolithic system operated without any training?**

I think not.  
The monolithic system was also operated presupposing many informal educations, such as:

- Unwritten rules,  
- Information passed verbally,  
- Undocumented dependencies,  
- Unclear divisions of responsibility

This method might not have been visible,  
but developers continuously spent **time and energy** in explanations, implicit guesses by newcomers, and repetitive questions and answers.

It's just that the cost wasn't structurally visible,  
but it was indeed always there.

MSA attempts to **formalize, document, and systematize** these learning costs.  
So, although the costs are visible,  
they are not a new burden but **a clarification of previously hidden costs**.

Furthermore, these costs will inevitably occur at some point.  
Therefore, it might be more stable and sustainable to start with a structure that presupposes education from the beginning,  
rather than hurriedly beginning education when it's time to switch structures.

> **Education is an unavoidable cost.**  
> It's just a matter of whether you delay it  
> or include it in the structure from the start.

---

## A Transparent Structure Is a Fast Structure

MSA often feels uncomfortable.  
Responsibilities are clearly revealed, boundaries are fixed, and dependencies are starkly exposed within the structure.  
These characteristics can be burdensome.

However, paradoxically, this transparency  
enables **faster decision-making and execution**, as I've experienced.

When the structure is transparent, there's less room to evade.  
- Bottlenecks can be quickly identified,  
- Delayed responses can be easily traced,  
- Broken contracts are clearly exposed.

In such a structure,  
- The number of communications decreases,  
- The time spent on consultations shortens,  
- Decision-making naturally decentralizes.

MSA inherently contains structural transparency.  
And this transparency doesn't increase management tasks but  
**appropriately distributes responsibilities, thereby reducing operational burdens**.

> A monolithic structure tends to hide problems,  
> while MSA exposes them.

Problems must be exposed to be solved,  
and as this exposure repeats, the structure is refined in a stronger direction.

Therefore, the perception that "MSA is uncomfortable" can be transformed in this way.

> **"MSA can feel uncomfortably transparent."**  
> However, that transparency is the foundation for  
> **ultimately creating a faster organization.**

---

## The Real Difficulty Is Not the Structure

MSA is often assessed as structurally difficult.  
However, most technologies can be learned through documentation and examples,  
and the necessary tools can also be used by borrowing existing open-source or cloud services.

Structural design can also be sufficiently improved through repetitive feedback,  
and modularization is not a difficult task once certain standards are set.

From my experience,  
the real difficulty lay in **handling the transparency created by the structure**.

A transparent structure clearly delineates responsibilities,  
reduces ambiguities, and distinctly divides each person's role.  
In this process, individuals or teams  
come face-to-face more directly with their decisions and outcomes.

That encounter can sometimes feel uncomfortable,  
and the movement to avoid that discomfort can appear as structural resistance.

Therefore, ultimately,  
the real difficulty was not the technical difficulty or design complexity,  
but **the cultural tension and personal attitude changes revealed through the structure**.

---

## In Conclusion

MSA is not simply a technology that divides structures.  
Rather, it is a cultural change that clearly defines responsibilities, redefines ways of collaborating,  
and allows the organization to transparently face its own tasks.

This transparency can be uncomfortable,  
but when we overcome that discomfort,  
we can create a faster and healthier system.

MSA is not difficult.  
It's just that its transparency is unfamiliar and not yet comfortable.

---

## Revision

- 2025-06-30: Added 'Communication Cost Increase' section
- 2025-06-30: Enhanced the sentence "Services should have boundaries established based on responsibility"
- 2025-06-30: First posted