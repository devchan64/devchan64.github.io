---
date: 2025-04-11
layout: post
permalink: /en/2025/04/11/not-tech-debt-just-ignorance.html
tags:
- Design Philosophy
title: '"It''s Not Technical Debt, It''s Just What We Didn''t Know"'
---
> `gpt-4-turbo` has translated this article into English.

--

### We are Confusing Ignorance with Technical Debt

# 1. Introduction: The Term "Technical Debt" Is Used Too Freely

Today, the term "technical debt" is frequently used in software development environments.  
This expression appears repeatedly in situations like:

- When the implementation of a feature becomes more complex than anticipated  
- When code structure becomes tangled  
- When unanticipated errors occur repeatedly  
- When something needs to be created quickly

In such instances, we readily say:  
> “It’s technical debt.”

This phrase functions like language that temporarily defers responsibility, leaving a vague expectation that it will be improved through refactoring someday.

However, when we actually look at the context in which it is used,  
it’s questionable whether it really was a "debt" in the true sense.  
Most often, it is a problem caused by the absence of design or lack of technical judgment, yet we still package it as "debt."  
As if it had been a strategic decision.

This article aims to critically examine the reality behind that facade.  
We will revisit the ignorance and mistakes buried under the name of technical debt, and examine the impact of a culture that avoids design on technical organizations.

---

# 2. The Culture of Masking Ignorance as Technical Debt

When many development teams face structural problems, they describe it as "technical debt."  
However, upon closer inspection, there were neither technical trade-offs nor any trace of judgment.

It was simply because they didn't know.  
And because they didn’t think it through enough.

- They did not understand why design was necessary  
- They cannot explain why the structure ended up this way  
- The basis for technical choices is not documented  
- No one looks to review those decisions

Yet, they say:  
> "It’s technical debt."  
> "There was nothing we could do at the time."  
> "We didn’t know then."  
> "We just implemented it this way. We can refactor it later."

This is not technical debt.  
It’s merely a lack of design, ignorance, and an unwillingness to take responsibility.

> *"If you don’t know why your system is built the way it is, chances are you’ll break it when you change it."*  
> — Martin Fowler, *Refactoring*  
>  
> If you don’t know why your system is built the way it is, you are likely to damage it when you change it.

Many of our systems are already following this path.  
Now, we need the courage to acknowledge the absence of technical judgment, rather than avoiding responsibility.

---

# 3. Technical Debt Is Not a Choice but a Declaration

The term "technical debt" implies a strategic choice.  
That is, despite recognizing that a better implementation could be possible, it means opting for a simpler method temporarily due to factors like schedule, priorities, or market responsiveness.

This is exactly why technical debt must be a **defined declaration**.  
Technical debt should be the result of a judgment, with recorded evidence clarifying **when, why, and what was compromised**.

However, the reality is different.

- It’s unclear who made the decision  
- What alternatives were available at the time are not even recorded  
- As structures become progressively more entangled, they are simply passed off as "technical debt"

> “It’s okay because it’s an MVP.”  
> “We created it quickly, but we can fix it later.”  
> “Features come first right now.”

These statements are not technical debt.  
They were not decisions, had no judgment, and no declaration.  
They are merely **unrecorded ignorance** and **fragments of unaccountable structure**.

> *“The whole point of the metaphor is that it's okay to do things quickly, as long as you pay it off.”*  
> — Martin Fowler, *Technical Debt Quadrant*  
>  
> The essence of the technical debt metaphor is that it’s okay to do things quickly only if there is a premise that you will pay off the debt.

If technical debt is not declared, then it is not debt.  
It is merely an unaccountable design.

---

# 4. Technical Debt Is Not Something to Be Managed

Many teams consider technical debt as something to be "managed."  
They leave tickets named "technical debt" in bug trackers or backlogs, promising to fix them when they have time.

However, in most cases, those tickets are not renewed.  
There is no repayment plan.  
There is no responsible person, and no one looks to review the structure again.

> “Let’s fix it someday, it’s technical debt.”  
> “We’ve put it in the management ticket.”  
> “Important features come first right now.”

This approach is not **management**.  
It’s closer to **neglect**.  
Technical debt is not something to be deferred under the name of management, but something to be **defined**, **repaid or discarded**.

> *“Managing technical debt isn’t about tracking tasks; it’s about avoiding becoming insolvent.”*  
> — Martin Fowler, *Technical Debt Quadrant*  
>  
> Managing technical debt is not about listing tasks; it’s about avoiding technical insolvency.

Technical debt cannot be resolved by simply using the word "management."  
It must be **clearly defined** and approached with an executable **repayment or disposal strategy**.

---

# 5. The Essence of Technical Debt Is the Lack of Design

Most of the technical debt we have discussed so far originates not from "strategic judgment" but from **unstructured design** or a culture **incapable of designing**.

Technical debt should ideally be the result of knowing a better structure but choosing a simpler path temporarily.  
However, we often start implementations without even imagining a better structure, or having the time, capability, or cultural leeway to do so.

The structural problems that arise as a result are not technical debt but **the consequences of a lack of design**.

- If it wasn’t documented  
- If it can’t be explained  
- If the structure is not understood  
Then, it is not debt but merely **the remnants of unaccountable code**.

To seriously address technical debt, we must **restore the act of designing itself**.

---

# 6. Design Is About Defining and Discarding

What is design, really?  
Many people think of design as documents, diagrams, or a set format.  
However, real design is not a fixed form.  
Design is the act of **defining** the flow, responsibilities, and connections of a system, and the judgment to **willingly discard it** when it is no longer valid.

Good design does not exist in a perfect form.  
Rather, it must meet the following conditions:

- It can explain why this structure was chosen  
- The context in which the design was valid is specified  
- If there is the courage to destroy and reconfigure the structure when needed  
Then, it is a living design.

> *“Architecture is the decisions you wish you could get right early, but you have to live with.”*  
> — Martin Fowler, *Who Needs an Architect?*  
>  
> Architecture is ideally getting decisions right from the start, but ultimately, it involves living with those decisions for a long time.

This statement shows how risky and heavy the choice of design can be.  
We avoid designing because we do not want to be responsible for those decisions.  
However, the cost of avoiding design will inevitably come back to haunt us.

If design is not defined, the system loses direction; if design is not discarded, the system stagnates.

Design itself is a **declaration** and a **living entity with an expiration date**.  
When it is **defined, shared, and can be discarded**, design truly becomes an asset to the team.

---

# 7. Conclusion: Restoring Design Revitalizes Technology

Technical debt is not just "something to fix."  
It is **the cost of not designing** and **the traces of unaccountable structures**.

Much of what we call technical debt was not actually technical debt.  
It was implementations without judgment, and products of a culture incapable of design.  
Yet, we often say:

> “We’re a startup, so it’s natural to have some debt.”  
> “We didn’t know better at the time, so it couldn’t be helped.”  
> “Features come first, so we’ll design later.”  
> “Let’s just build it now, and refactor it later.”  
> “It’s technical debt, so we’ll sort it out someday.”

These expressions conceal **avoidance, ignorance, and lack of responsibility**.  
As long as such a culture continues, we will repeat the same problems and create more technical suffering.

Design is the beginning and the end of technology.  
A culture that does not design treats technology as disposable and developers as expendable.

It’s time to declare:

- Design must be defined.  
- Design must be shared.  
- Design must be able to be discarded.

The recovery of technical organizations begins with **the restoration of design**.  
To move beyond technical debt, we must return to the language of design, the responsibility of structure, and the thinking of connections.