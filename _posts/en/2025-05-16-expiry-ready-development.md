---
date: 2025-05-16
layout: post
permalink: /en/2025/05/16/expiry-ready-development.html
tags:
- Design Philosophy
- Organizational Culture
- Technical Debt
- Startup
title: 'Advocating Expiry-Ready Development Methods: Minimalist Knowledge Management
  Strategies for Startups'
---

> `gpt-4-turbo` has translated this article into English.

---

# Preface: What is Expiry-Ready?

> Let's prepare to give way to better code

**Expiry-Ready code** is not simply **code to be deleted**.  
It refers to **code that is ready to be archived and deleted or transferred if necessary**.  
Expiry-Ready embodies the philosophy that code or systems should be ready to be immediately deleted or transferred when they are no longer needed.  
It is a design philosophy that prepares in advance to delete or transfer immediately.

Meaning of Expiry-Ready:
**Expiry-Ready code** refers to a state of readiness for features that are no longer used or no longer need to be activated.

> The reason why we use the term **"deletion"** rather than **"expiration"** is to view it as an action that involves deliberate judgment and execution, not just something that disappears over time.

This involves code designed with the possibility of deletion in mind, and the process of recording and preparing the necessary information (Owner, Purpose, Expiry Condition, etc.) for removing a feature or excluding it from the system.

Expiry-Ready is not just about "deletion", but a proactive management method to efficiently organize unnecessary code or features and reduce the risks of **Technical Debt** and **Software Rot**.

---

# I. Getting Started: Development Risks Startups Must Face

Startups need to build and verify quickly.  
However, in the process, unmanaged code, neglected features after experiments, and forgotten repositories accumulate.  
Over time, this develops into serious issues such as:

- Technical Debt
- Software Rot
- Increased System Complexity
- Maintenance Cost Explosion

This article presents ways to minimize unnecessary knowledge and management and structurally prevent through better code design.
And the core of this approach is **Expiry-Ready Development Theory**.

> **"Having the courage to remove, rather than create, preserves a startup."**

---

# II. Expiry-Ready Philosophy: Why Should We Prepare Code for Deletion?

### Development culture does not start with code

Development culture does not start with tools or processes.  
It begins with the organization's mindset, leadership standards, and the technical philosophy shared by the team.

And our philosophy is clear:

> **"Code should always be ready to be deleted."**

### Design is not a matter of technology but of standards

The start of design is not about which technology to use, but  
about setting standards and thinking about how to structure the system and what to remove when it is no longer needed.

- What will be the focus of dividing the system?
- How to define and assign responsibilities to features?
- What structure will give us flexibility?

Teams with clear standards design not only **"creation"** but also  
**"removal"**.

### Agile is complete when you can experiment and delete

Agile is not about tools like Jira or sprints.  
The essence of agile is the **speed of verification and learning**.

- How quickly can you verify the value the customer wants?
- How quickly can you remove it if it fails?

True agility is  
impossible without **Expiry-Ready design**.

> **"Failure is not to be accumulated, but deleted and learned from."**

---

# III. Expiry-Ready Structure: Creating a Living System

### What is an Expiry-Ready structure?

All code will disappear someday.  
What matters is whether it is built anticipating that.

This is how we design:

- Assume the lifespan of code when creating it
- Isolate code with a short lifespan
- Organize code that lasts longer

An Expiry-Ready structure follows these principles:

| Principle | Description |
|:---|:---|
| Loose Coupling | Minimize connections between functions to ensure independence |
| Separation of Concerns | Design so that one module has only one role |
| Delegatable | Structure to allow external replacement or disposal |
| Experiment-Friendly | Aim for a structure that can be easily attached and removed |

### Small successful experiences

We have experienced several times that code started as a simple utility,  
- grew into an independent module through repeated use, and  
- cleanly removed unnecessary parts,  
- simplifying the entire system.

This experience has given us confidence.

> **"An Expiry-Ready structure creates a living system."**

---

# IV. Expiry-Ready Practice

### Leave a record at the time of creation

When creating code or a repository, always record the following:

- **Owner**: Who is responsible for this code/repository?
- **Purpose**: Why does this code/repository exist?
- **Expiry Condition**: When can this code/repository be disposed of?
- (Optional) **Dependency**: Where is it connected?
- (Optional) **Change History**: What are the major changes?

**The purpose of writing is not just for documentation.**  
**It's to record the "possibility of deletion."**

### Detect signs of being unmanaged

If the activity of the Owner significantly decreases over time,  
the code/repository approaches **Unmaintained** status.

We regularly monitor the following:

- Number of commits in the last month
- Number of commits in the previous month

**If a noticeable decrease is detected, an Expiry-Ready Record is created.**

### Leave an Expiry-Ready Record

- Clearly document the possibility of deletion and conditions for expiry.
- Store in a central system (e.g., GitHub Issue, Notion, dedicated repo).
- Refer to it later when deciding to delete/transfer/preserve.

> **"Deletion is judged by records, not intuition."**

---

# V. Making Deletion a Culture

### Deletion is not refactoring, but ending responsibility

Deletion is not just tidying up code.  
It is a process where the team clearly decides that a function or code is no longer needed and systematically carries it out.

If refactoring is about improving the internal structure while keeping the function, deletion is a decision that the function itself is no longer needed.  
It is the ending of responsibility and redefining the system boundaries.

Deletion is explicitly declared by the team:

> **"This function is no longer part of our system."**

Deletion means:

- Removing technical debt
- Reducing the amount of knowledge to manage
- Reducing system complexity

### Practice deletion as a culture

We incorporate deletion into the regular development process as follows:

- Ask in **code reviews**, "Can this be deleted later?"
- Specify deletion intentions with **naming** like `temporary-`, `experimental-`.
- Manage **deleted Lines of Code (LOC)**, **number of discarded modules** as **KPIs**.
- Reflect on and share **good deletion cases** every quarter.

### Do not leave failures behind

When an experiment fails, we ask ourselves:

> **"Is this feature ready to be cleanly removed if it fails?"**

If we cannot answer, we do not start the experiment.

---

# VI. Learning and Dissemination: Minimizing Knowledge Management Strategy

### Principles of minimizing knowledge management

We design systems so that the team does not rely on memory.  
For this, we follow these principles:

- **Explain designs through documentation, not verbally.**
- **Organize repeated questions into a knowledge base.**
- **Document experiments, and leave deletions as history.**

### Record both experiments and deletions

- Record the background and results of experimental features in Notion, GitHub Discussions, etc.
- Clearly leave why a feature was deleted.
- Use past decisions as a basis when re-requirements arise.

### The first principle taught to new members

We teach new team members these principles before coding rules:

> **"Learn deletion design principles before writing principles."**

- Always imagine an expiry date when writing a feature.
- Prioritize sustainability in the system.

### Questions to repeatedly ask

- When can this feature disappear?
- How can it be discarded if it fails?
- Does it impact other services?

Through these questions, we consider **the lifespan of the design itself**.

---

# VII. Reaffirming as a Philosophy

We design code to be deletable.  
We always prioritize a structure that can be reduced.  
This is not just a technical methodology, but our technological philosophy and team identity.

> **"The surviving code is the code that is ready to be deleted."**

And this philosophy determines our team's design and  
creates our development culture.

We learn to remove more courageously rather than just creating more code.

As the system grows,  
as the team grows,  
we repeatedly ask:

> **"Is this code, this structure ready to be deleted?"**

In the flow of creating, experimenting, and removing,  
startups stay alive and can grow.

> **"Deletion is not just cleaning up the system, but organizing the team's responsibilities."**