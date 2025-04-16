---
date: 2025-03-10
layout: post
permalink: /en/2025/03/10/why_we_should_delete_code.html
tags:
- Design Philosophy
- Organizational Culture
title: Why Do We Need to Delete Code?
---
> `gpt-4-turbo` has translated this article into English.
---

# I. Understanding Philosophy

### 1. Development culture does not start with the code

Development culture is not created by tools or processes. It starts with the organization's mindset, the standards of leadership, and the technical philosophy shared by the team. This article discusses how we design and what philosophy we use to create our development culture. At the center of this is the strong belief that "code should always be deletable."

### 2. Design is not a technical problem, but a standard issue

Design, before tech stacks or design patterns, is about under what standards we are creating systems. Design without standards can easily lose direction and only increases technical complexity.

What we mean by standards is the **central axis of decision-making** about what centers our systems, determines functions, and judges what structures can offer flexibility.

Teams with clear standards focus not only on what functions to create but also on **when functions can be removed**. Teams with vague standards focus solely on creation, which ultimately increases maintenance costs and risks.

The 'user status tag feature' kept expanding due to changes in planning, and the added conditional statements and flags without a design standard destabilized the entire user system. Later, the standard that "tags must always be disposable" was set, and by separating into an external JSON schema, it became a structure that could be removed at the end of the experiment.

> "Can this be deleted later?"
> 

### 3. Agile is not a tool, but a speed of verification and learning

Many teams understand agile through processes like Jira, Sprint, and Retrospective. However, the essence of agile we believe in lies in **how quickly can we verify the value customers want and how quickly can we learn from it**.

To maintain this speed, systems must always be flexible, and this flexibility comes from a **deletable structure**. Only then, true agility in design, which can be experimented with and removed, is possible.

After releasing a feature under an 'experiment flag', if feedback is negative, the entire code and settings are deleted. Failure was transformed into learning, and the team could quickly change direction.

---

# II. Creating Structure

### 4. Deletable Structures, Living Systems

All code will disappear eventually. What matters is whether it is created with that expectation. We design assuming the lifespan of the code, isolating short-lived code, and structuring long-lasting code.

Deletable structures mean low dependency, separated responsibilities, and delegatable structures.

| Principle | Description |
| --- | --- |
| Loose Coupling | Minimize connections between functions to ensure independence |
| Separation of Responsibility | Design so that one module has only one role |
| Delegatable | Structure that can be replaced or discarded externally |
| Experiment Friendly | Easy to attach and remove structure |

The notification system initially started as a simple utility, but with repeated use, it was promoted to an independent module and external integration service. The initial implementation was neatly removed, simplifying the system.

---

# III. Implementing

### 5. 'Deletion' as a Development Culture

Deletion carries responsibility. Deletion is not just refactoring but a **consensus that the team will no longer maintain something** and **an act of organizing intentions and ending responsibilities**. We record the deletion log and its impact range together.

**Examples of practicing deletion culture:**

- In code reviews, ask "Can this be deleted later?"
- Use `temporary-`, `experimental-` naming to indicate the intention to delete
- Make deleted LOC, number of removed modules, and discarded features into KPIs

The 'event banner management feature' was a temporary function, but the timing of its disposal was missed, burdening system testing. With the decision to remove it, a retrospective was shared, and subsequently, a culture of clearly tagging experimental features and setting disposal cycles was established.

When we face a problem, we ask ourselves:

> "Is this a problem I can answer now?"
> 

If not, we share a plan of exploration rather than proposing a solution:

- Check if I know a solution
- If not, share the scope and period of exploration
- Define the schedule not by the result but by the 'time to find'

This is precisely the practice of a deletable culture, **a way to remove uncertainty and complexity**.

> "Removing well is more skillful than creating much."
> 
> "Deletion is an act of the team organizing responsibilities."
> 

---

# IV. Learning and Disseminating

### 6. Information Sharing and Knowledge Base

**Questions asked at the design stage:**

- When can this feature disappear?
- Does it affect other services?
- How can it be disposed of if it fails?

These questions are about designing the **lifespan of the design itself**.

**Principles of knowledge sharing:**

- Explain design through records, not verbally
- Organize repeated questions in a knowledge base
- Document experiments, and keep deletions as history

We use Notion and GitHub Discussions to record the background and process of experiments and specify the reasons for deleted features to use as a basis for decision-making when they are requested again.

Additionally, we retrospect "well-deleted cases" every quarter, and for new team members, we first teach the **principles of deletion design** rather than mere writing principles. This is more important than simple technical syntax and is our team's philosophy.

---

# V. Reinforcing Through Philosophy

### 7. We are a team that deletes

We always create structures intended to reduce code. This is both a technical philosophy and the identity of our team.

> "The code that survives is the code that is ready to be deleted."
> 

And this philosophy determines our team's design and creates our development culture.

We learn the courage to reduce before we learn to create.

---