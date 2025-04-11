---
date: 2025-04-11
layout: post
permalink: /en/2025/04/11/not-tech-debt-just-ignorance.html
tags:
- Design Philosophy
title: '"That''s Not Technical Debt. It''s Just What We Didn''t Know."'
---
> `gpt-4-turbo` has translated this article into English.

--

### We are Confusing Ignorance with Technical Debt

# 1. Introduction: The Term "Technical Debt" is Overused

In today's software development landscape, the term "technical debt" is frequently used.  
It appears repeatedly in situations like:

- When feature implementations become more complex than anticipated  
- When code structures become entangled  
- When unexpected errors recur  
- When something needs to be built quickly

In such times, we easily say:  
| "It's technical debt."

This expression operates like a language that temporarily defers responsibility, leaving a vague expectation that it will be improved through refactoring someday.

However, if we look closely at the context in which the term is used,  
it is questionable whether it truly represents 'debt'.  
Most often, these are issues arising from a lack of design or technical judgment, yet we still package these issues as 'debt'  
as if they were the result of strategic decision-making.

This article aims to critically examine the reality behind this packaging.  
We will revisit the ignorance and mistakes buried under the name of technical debt and explore how a culture of design avoidance impacts tech organizations.

---

# 2. The Culture of Masking Ignorance as Technical Debt

When many development teams face structural problems, they explain them as 'technical debt'.  
But if you dig deeper, there was neither a technical trade-off nor any trace of deliberation.

Simply put, it was because they did not know.  
And they did not think it through enough.

- They did not understand why design was necessary  
- They cannot explain why the structure ended up this way  
- The basis for technical choices is not documented  
- No one revisits those decisions

Yet, they say:  
| "It's technical debt."  
| "There was no choice at that time."  
| "We didn't know then."  
| "We just implemented it this way. We can refactor later."

This is not technical debt.  
It is merely the absence of design, ignorance, and a reluctance to take responsibility.

> *"If you don’t know why your system is built the way it is, chances are you’ll break it when you change it."*  
> — Martin Fowler, *Refactoring*  
>  
> If you don't know why your system was built the way it was, you are likely to damage it when you try to change it.

Many of our systems are already on this path.  
Rather than avoiding responsibility, we need the courage to admit that there was no technical judgment involved.

---

# 3. Technical Debt is Not a Choice but a Declaration

The term technical debt implies a strategic choice.  
It means that despite recognizing that a better implementation was possible, a simpler method was temporarily chosen due to considerations like schedule, priorities, or market response.

This is why technical debt must be a **defined choice**.  
It should be the result of deliberation, with documented reasons for **when, why, and what was compromised**.

However, reality is often different.

- It's unclear who made the decision  
- It's not recorded what options were available at the time  
- Even as structures repeatedly become tangled, they are simply passed off as "technical debt"

| "It's okay because it's just an MVP."  
| "We built it quickly, but we can fix it later."  
| "Functionality comes first right now."

These statements are not technical debt.  
They were not decisions, there was no deliberation, and no declaration.  
They are just **undocumented ignorance** and **fragments of unaccountable structures**.

> *“The whole point of the metaphor is that it's okay to do things quickly, as long as you pay it off.”*  
> — Martin Fowler, *Technical Debt Quadrant*  
>  
> The essence of the technical debt metaphor is not that it's okay to proceed quickly,  
> **but that it's only okay if you plan to pay off the debt.**

If technical debt is not declared, then it is not debt.  
It is simply an unaccounted design.

---

# 4. Technical Debt is Not Something to be Managed

Many teams consider technical debt as something to be 'managed'.  
They leave tickets labeled 'technical debt' in bug trackers or backlogs, promising to fix them when there's more time.

However, in most cases, these tickets are not revisited.  
There is no plan for repayment.  
There is no responsible person, nor anyone looking to reevaluate the structure.

| "Let's fix it sometime since it's technical debt."  
| "I've put it in the management ticket."  
| "Right now, important features come first."

This approach is not **management**.  
It is closer to **neglect**.  
Technical debt should not be something postponed under the guise of management but should be **defined**, **repaid**, or **discarded**.

> *“Managing technical debt isn’t about tracking tasks; it’s about avoiding becoming insolvent.”*  
> — Martin Fowler, *Technical Debt Quadrant*  
>  
> Managing technical debt is not about listing tasks, but about  
> **preventing technical bankruptcy**.

Technical debt cannot be resolved merely with the word 'management'.  
It must be **clearly defined**, with actionable **repayment or disposal strategies**.

---

# 5. The Essence of Technical Debt is the Absence of Design

As we have seen, most of what we call technical debt is not really 'strategic judgment' but rather **structures that were not designed** or a culture **incapable of designing**.

Technical debt should logically be the result of knowing a better structure but choosing a simpler path temporarily.  
However, we often start implementations without even imagining a better structure, lacking the time, capability, or cultural freedom to do so.

The structural problems that emerge are not technical debt but **the results of a lack of design**.

- If it is not documented  
- If it cannot be explained  
- If the structure is not understood  
then it is not debt but merely the **remnants of code without responsibility**.

To seriously address technical debt, we must **restore the act of designing itself**.

---

# 6. Design is Defining and Discarding

What is design?  
Many people think of design as documents, diagrams, or a fixed structure.  
But real design is not a fixed form.  
Design is the act of **defining the flow, responsibilities, and connections of a system**, and it is also the judgment to **willingly discard it when it is no longer valid**.

Good design does not exist in a perfect form.  
It must instead satisfy the following conditions:

- It can explain why this structure was chosen  
- The context in which the design was valid is specified  
- If there is the courage to destroy and reconstruct the structure when necessary  
then it is a living design.

> *“Architecture is the decisions you wish you could get right early, but you have to live with.”*  
> — Martin Fowler, *Who Needs an Architect?*  
>  
> Architecture is about decisions that would have been nice to get right from the start but ultimately you have to live with for a long time.

This statement shows how risky and heavy a choice design can be.  
We avoid designing because we don't want to be responsible for those decisions.  
However, the cost of avoiding design will inevitably return.

If we do not define design, the system loses direction, and if we cannot discard design, the system stagnates.

Design itself is a **declaration and a living organism with an expiration date**.  
When it is **defined, shared, and can be discarded**, only then does design become an asset to the team.

---

# 7. Conclusion: Reviving Design is Essential for Technology to Thrive

Technical debt is not merely "something to fix."  
It is the **cost of not designing** and the **trace of unaccountable structures**.

What we often call technical debt is actually implementation without judgment and the product of a culture incapable of designing.  
Despite this, we often say:

| "It's normal for startups to have debt."  
| "We didn't know better at that time, so it was unavoidable."  
| "Functionality comes first, so we'll design later."  
| "Just build it now, and we can refactor later."  
| "It's technical debt, so we'll sort it out someday."

These statements conceal **evasion, ignorance, and irresponsibility**.  
As long as such a culture continues, we will repeat the same mistakes and create more technical pain.

Design is both the beginning and the end of technology.  
A culture that does not design treats technology as disposable and developers as expendable.

Now we must declare:

- Design must be defined.  
- Design must be shared.  
- Design must be discardable.

The recovery of technology organizations begins with **the revival of design**.  
To move beyond technical debt, we must return to the language of design, the responsibility of structure, and the thought process of connections.