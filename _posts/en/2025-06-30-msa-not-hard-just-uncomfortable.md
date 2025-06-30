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
They advise to separate services, make contracts clear,  
dividing responsibilities, and localize failures are also emphasized.

However, as these conversations continue,  
it becomes apparent that not a few lack actual implementation experience with such structures.

This article summarizes some small insights and interpretations gained through structuring and operating MSA firsthand,  
forming actual teams, experiencing failures, and through the process of separating and reintegrating systems.

The perception that MSA is difficult,  
claims of high initial implementation costs,  
and concerns that it burdens the organization.

I want to calmly examine where these claims come from,  
and what fears and avoidance are hidden behind them,  
from the perspective of someone with experience.

> **MSA is not difficult. It's just excessively transparent, which might be uncomfortable.**

---

## Is MSA Really Difficult?

Many organizations hesitate to adopt MSA.  
You often hear that "it is costly," "the structure is complex," or "it is not suitable for early-stage startups."

But reflecting on the cases I have experienced,  
it seems that these judgments were not entirely due to the structural limitations of MSA itself.

From what I have observed:  
- A culture where responsibilities are not clearly divided,  
- Unclear contractual relationships,  
- A code structure that facilitates hiding problems,  
- An atmosphere that resists experimentation  
often led to greater costs.

> **The feeling that MSA is costly might be because the structure is transparent.**  
> Previously unseen inefficiencies may have become visible as a result.

Had we started with a modular structure in mind from the beginning,  
small failures could have been easily fixed, and  
new attempts could have been made without much burden.

Ultimately, the issue was not so much the structure itself,  
but the attitude and approach towards the transparency it revealed.

---

## It Wasn't Scary Because We Started With Modules

Designing a perfect structure from the beginning is difficult.  
However, a deletable structure, a design with separated boundaries,  
and a mindset that it can always be rebuilt were sufficiently achievable.

In the early stages of development, we chose to divide functions into modules.  
We separated each function into independent files and tried to keep execution units small.  
As a result, we could respond by replacing or removing only the problematic modules without discarding the entire system.

This approach made a structure where failure was not something to be greatly feared.  
- Refactoring was freely performed,  
- A/B testing could be tried relatively easily,  
- The scope of responsibility in the code gradually became clear,  
- The structure was slowly refined through repeated experimentation.

The starting point for these outcomes was 'modular thinking.'

In fact, the approach of dividing into modules was not something special.  
Windows operating system's DLLs, Java's class loaders, Python's `importlib`, etc.,  
have long followed the same principles.  
About 15 years ago, a module loader I personally implemented was also part of this trend.

> **A dynamically loadable structure** signifies not just technical convenience.  
> It was an approach that allows failure, offering structural leeway.

MSA did not start based on an elaborate framework either.  
It began with somewhat outdated but flexible methods, and  
ultimately, I felt it secured greater resilience at lower costs.

---

## Attitude is Harder Than Technology

People often say MSA is difficult.  
API gateways, inter-service authentication, message brokers, CI/CD, container orchestration, etc.,  
require learning many technical elements.

Of course, there is a lot to learn.  
But over time, you realize:  
These technologies have well-organized documentation, examples, and active communities.  
Ultimately, they are areas that can be mastered with time.

What's harder than technology is the **attitude**.

MSA is not only a technical structure but also fundamentally presupposes an attitude of **distributing responsibilities, respecting boundaries, and adhering to contracts**.  
And these responsibilities involve discomfort.

- When responsibilities are clear, avoidance becomes difficult.  
- When interfaces are organized, excuses diminish.  
- When monitoring systems are set up, "I didn't know" loses its persuasiveness.

The reason MSA feels difficult is not so much the technical difficulty of the technology itself,  
but **because it requires facing the attitude demanded by that structure**.

> **Structure is a device that reveals responsibility, and MSA does not hide it.**

---

## What's Needed is Not Technology, but the Recognition of its Need

Dividing structures itself is not difficult.  
Designing APIs, separating services, and deploying with containers are tasks well within the range of skilled developers.

However, continuously operating, maintaining, and making the structure scalable  
cannot be achieved by technology alone.  
At its core was **culture**.

MSA asks people through its structure:  
- Do you know what your responsibilities are?  
- Are you calling services that need not be called?  
- When a contract changes, who and how should you communicate?

Ultimately, I realized that MSA is not just a matter of technological adoption or structural design,  
but a problem of **cultivating a culture that divides responsibilities, moves based on trust, and trains autonomy**.

If this culture is not formed, adopting the structure alone could lead to greater complexity,  
make it difficult to identify the causes of problems,  
and increase fatigue within the team.

Therefore, what's important is not just the adoption of technology,  
but understanding why that structure is necessary and  
having a cultural awareness that everyone can share.

> **MSA is a process of agreeing on how to live together before designing the structure.**  
> Within it, people learn responsibilities, repeat collaboration, and build trust.

---

## Education is an Inevitable Cost

In discussions related to MSA adoption, the same concern often arises:  
The claim that "education costs are too high."

Changing structures requires retraining teams,  
changes in people's mindsets are necessary,  
and there is the burden of having to learn new tools instead of familiar ones.

These concerns are understandable.  
But it's worth asking one question:

> **Really, was the monolithic system operated without any training?**

I believe that was not the case.  
Monolithic systems also presupposed a lot of informal education in the following forms:

- Unwritten rules,  
- Information passed orally,  
- Undocumented dependencies,  
- Unclear division of responsibilities

This method might not have been visible,  
but it continuously consumed **time and energy** through developers' explanations, newcomers' implicit guessing, and repetitive questions and answers.

The cost was just not structurally visible,  
but it has always been there.

MSA attempts to **formalize, document, and systematize** these learning costs.  
So, while the costs become visible,  
it's not a new burden but rather **a clarification of previously hidden costs**.

Furthermore, such costs will inevitably occur at some point.  
Therefore, rather than hastily starting education at the point of needing to change structures,  
**starting with a structure that presupposes education from the beginning**  
could be a more stable and sustainable choice.

> **Education is an inevitable cost.**  
> The difference lies in whether you delay it or include it in the structure from the beginning.

---

## A Transparent Structure is a Fast Structure

MSA often feels uncomfortable.  
Responsibilities are clearly exposed, boundaries are fixed, and dependencies are starkly revealed within the structure.  
These characteristics can be burdensome.

However, paradoxically, this transparency  
enables **faster decision-making and execution**, as I have experienced.

With a transparent structure, there is less room for avoidance.  
- You can quickly identify where bottlenecks occur,  
- Easily trace where responses are delayed,  
- And clearly see where contracts have been broken.

In such a structure:  
- The number of communications decreases,  
- The time spent in consultations is reduced,  
- And decision-making naturally becomes more distributed.

MSA inherently contains transparency.  
And this transparency does not increase management tasks but rather **reduces the burden of operations by appropriately distributing responsibilities**.

> A monolithic structure tends to hide problems,  
> MSA is a structure that exposes them.

Problems need to be exposed to be solved,  
and as such exposure is repeated, the structure is incrementally refined towards greater resilience.

Thus, the perception that "MSA is uncomfortable" can be transformed like this:

> **"MSA may feel uncomfortable because it's excessively transparent."**  
> But that transparency is precisely what forms the foundation for a faster organization.

---

## The Real Difficulty Isn't the Structure

MSA is often assessed as structurally difficult.  
But in reality, most of the technology can be learned through documentation and examples,  
and the necessary tools can also be utilized by adopting existing open-source or cloud services.

Structural design can also be sufficiently improved through iterative feedback,  
and modularization is not a difficult task once certain standards are set.

From my experience,  
the real challenge was **dealing with the transparency created by the structure itself**.

A transparent structure clearly exposes responsibilities,  
reduces ambiguities, and distinctly divides each person's role.  
In this process, individuals or teams are  
confronted more directly with their decisions and outcomes.

That confrontation can sometimes feel uncomfortable,  
and the movement to avoid that discomfort can manifest as structural resistance.

So, in the end,  
the real difficulty is not the technical difficulty or design complexity,  
but **the cultural tension and personal attitude changes revealed by that structure**.

---

## In Conclusion

MSA is not simply a technology for dividing structures.  
Rather, it is about clearly defining responsibilities, redefining collaboration methods, and  
enabling organizations to transparently confront their own work.

This transparency can be uncomfortable,  
but beyond that discomfort,  
I believe we can build a faster and healthier system.

MSA is not difficult.  
It's just that its transparency is unfamiliar and not yet comfortable.