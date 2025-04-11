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

| We are Confusing Ignorance with Technical Debt

## 1. Introduction: The Term "Technical Debt" Is Being Used Too Liberally

In today's software development scene, the term "technical debt" is often used.  
It appears repeatedly in situations like the following:

- When feature implementation becomes more complicated than expected  
- When the code structure becomes tangled  
- When unexpected errors occur repeatedly  
- When something needs to be created quickly

In such cases, we easily say,  
| "It's technical debt."

This phrase acts like a language that temporarily defers responsibility, leaving a vague expectation that it will be improved through refactoring someday.

However, when looking closely at the context in which the term is used,  
one might question whether it truly was 'debt' in its genuine sense.  
In most cases, these are issues arising from a lack of design or technical judgement, yet we still package these as 'debt,'  
as if it were a strategic decision.

This article aims to critically examine the reality behind this facade.  
We will revisit the ignorance and mistakes buried under the name of technical debt, and explore how a culture of avoiding design impacts technical organizations.

---

## 2. The Culture of Packaging Ignorance as Technical Debt

When many development teams face structural problems, they describe them as "technical debt."  
However, upon closer inspection, there was neither technical trade-off involved nor any trace of judgement.

It was simply because they did not know.  
And because they did not think it through enough.

- They did not understand why design was necessary  
- They cannot explain why the structure ended up this way  
- The basis for technical choices is not documented  
- No one revisits those decisions

Yet they say,  
| "It's technical debt."  
| "There was no choice back then."  
| "We didn't know at that time."  
| "We just implemented it this way. We can refactor later."

This is not technical debt.  
It is merely a lack of design, ignorance, and a reluctance to take responsibility.

> *"If you don’t know why your system is built the way it is, chances are you’ll break it when you change it."*  
> — Martin Fowler, *Refactoring*  
>  
> If you don’t know why your system is built the way it is, you are likely to damage it when you try to change it.

Many of our systems are already on this path.  
Now, we need the courage to admit that there was no technical judgement, rather than avoiding responsibility.

---

## 3. Technical Debt Is a Declaration, Not a Choice

The term "technical debt" implies a strategic choice.  
That is, even though a better implementation was possible, a simpler method was temporarily chosen considering factors like schedules, priorities, or market responses.

This is exactly why technical debt must be a **defined choice**.  
Technical debt should be the result of a decision, with clear records of **when, why, and what was compromised**.

However, the reality is different.

- It is unclear who made those decisions  
- No records of the available options at that time remain  
- Even as structures become increasingly tangled, they are simply passed off as "technical debt"

| "It's okay to have technical debt because we're an MVP."  
| "We built it quickly, but we can fix it later."  
| "Right now, functionality comes first."

These statements are not technical debt.  
They were not decisions, there was no judgement, and no declaration was made.  
They are merely **unrecorded ignorance** and **fragments of an unaccountable structure**.

> *“The whole point of the metaphor is that it's okay to do things quickly, as long as you pay it off.”*  
> — Martin Fowler, *Technical Debt Quadrant*  
>  
> The essence of the technical debt metaphor is not that it’s okay to do things quickly, but  
> **it’s only okay if you have the premise of paying off the debt.**

If technical debt is not declared, then it is not debt.  
It is merely an unaccountable design.

---

## 4. Technical Debt Is Not an Object of Management

Many teams consider technical debt as something that "needs to be managed."  
They leave tickets named "technical debt" in bug trackers or backlogs, promising to fix them when there is more time.

However, in most cases, those tickets are not revisited.  
There is no repayment plan.  
There are no responsible parties, nor anyone looking to review the structure again.

| "Let's fix it someday because it's technical debt."  
| "I've put it in the management ticket."  
| "Right now, important features come first."

This approach is not **management**.  
It is closer to **neglect**.  
Technical debt should not be something deferred under the guise of management, but something to be **defined**, **repaid**, or **discarded**.

> *“Managing technical debt isn’t about tracking tasks; it’s about avoiding becoming insolvent.”*  
> — Martin Fowler, *Technical Debt Quadrant*  
>  
> Managing technical debt is not about listing tasks, but  
> **about preventing technical insolvency.**

Technical debt cannot be resolved by simply using the word "management."  
It must be **clearly defined**, and handled with an executable **repayment or disposal strategy**.

---

## 5. The Essence of Technical Debt Is the Absence of Design

Most of what we have examined as technical debt is not actually "strategic judgement," but rather **unplanned structures**, or the result of a culture **incapable of planning**.

Technical debt should only stand if it is the result of **choosing a simpler path temporarily, knowing a better structure**.  
However, we often start implementations without even imagining a better structure, or without the time, capability, or cultural leeway to do so.

The resulting structural problems are not technical debt but **the outcomes of a lack of design**.

- If it's not documented  
- If it cannot be explained  
- If the structure is incomprehensible  
then it is not debt, but merely the **remnants of unaccountable code**.

To seriously address technical debt, we must **restore the act of designing**.

---

## 6. Design Is about Defining and Discarding

What is design?  
Many people think of design as documents, diagrams, or a fixed structure.  
However, real design is not a fixed form.  
Design is the act of **defining** the flow, responsibilities, and connections of a system, and the judgement to **willingly discard** it when it no longer serves its purpose.

Good design does not exist in a perfect form.  
Rather, it must satisfy the following conditions:

- It can explain why this structure was chosen  
- The context in which the design was valid is specified  
- If there is the courage to destroy and reconfigure the structure when needed  
then it is a living design.

> *“Architecture is the decisions you wish you could get right early, but you have to live with.”*  
> — Martin Fowler, *Who Needs an Architect?*  
>  
> Architecture involves decisions that would have been nice to get right from the start, but you end up living with for a long time.

This statement shows how risky and heavy a choice design can be.  
We avoid designing because we do not want to take responsibility for those decisions.  
However, the cost of avoiding design will eventually return to us.

If we do not define design, the system loses direction, and if we cannot discard design, the system becomes stagnant.

Design itself is a **declaration and a living entity with an expiration date**.  
When it is **defined, shared, and can be discarded**, it truly becomes an asset to the team.

---

## 7. Conclusion: Reviving Design Is Essential for Technology to Thrive

Technical debt is not simply "something to be fixed."  
It is the **cost of not designing** and the **traces of an unaccountable structure**.

What we often call technical debt is actually implementations without judgement and products of a culture incapable of designing.  
Yet, we often say,

| "We're a startup, so it's natural to have debt."  
| "We didn't know back then, so there was nothing we could do."  
| "Features come first, we'll think about design later."  
| "Let's just build it first, and refactor later."  
| "It's technical debt, we'll sort it out someday."

These expressions conceal **avoidance, ignorance, and irresponsibility**.  
As long as this culture persists, we will repeat the same problems and generate more technical pain.

Design is both the beginning and the end of technology.  
A culture that does not design treats technology as a consumable and developers as disposable.

It is time to declare:

- Design must be defined.  
- Design must be shared.  
- Design must be able to be discarded.

The recovery of technical organizations begins with the **revival of design**.  
To move beyond technical debt, we must return to the language of design, the responsibility of structure, and the thought of connectivity.