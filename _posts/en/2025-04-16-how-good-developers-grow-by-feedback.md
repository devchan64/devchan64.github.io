---
date: 2025-04-16
layout: post
permalink: /en/2025/04/16/how-good-developers-grow-by-feedback.html
tags:
- Organizational Culture
- Leadership
- Design Philosophy
- Onboarding
title: How Do Good Developers Grow Through Evaluation?
---

> `gpt-4-turbo` has translated this article into English.

---

Performance evaluation is a sensitive topic for developers and can sometimes be exhausting.  
However, if the true desired image of a developer is clearly defined, evaluation can transform from a ranking tool to a **method for growth and cultural training**.

This is a discussion on how to **define the standards of a good developer**, **operate performance evaluation as a culture** based on those standards, and ultimately **create a structure that accumulates reliable outputs in the team**.

---

# 1. Why Should Evaluation Serve Culture?

Evaluating the performance of developers is always challenging.  
Quickly creating features doesn't necessarily mean good performance, and writing lots of code doesn't guarantee valuable outcomes.

Evaluation methods that focus solely on metrics can **shrink the team**, induce comparisons among developers, and **strengthen competition over collaboration**.

Instead, we aim to first define **"What do we consider a good developer?"** and based on that, create a structure where the team can **train and grow repeatedly**.

> **The purpose of evaluation is not to rank but to establish standards that allow the team to grow together.**

And these standards become outputs that are documented and coded, eventually becoming the culture of the team itself.

---

# 2. Defining What We Expect from a Good Developer

The criteria for judging a good developer are not fixed.  
Because technology stacks, projects, and teams vary.

**Therefore, the first thing to do is to define what a 'good developer' means to our team.**

Instead of finding a universal standard that applies to all situations, we gradually refine **who is the developer our team wants to work with?** based on our specific criteria.

This definition is not a checklist but a collection of **philosophies and habits** that the team organizes as it grows.

Currently, our important criteria include:

## 🧼 Deletable Code

> **Code should be structured to be deletable at any time, not just written to be kept.**

We value code that can be deleted without collapsing the entire system more than well-made features.  
Ideal code has low dependencies, separated responsibilities, and can adapt flexibly to domain changes.

To write deletable code, consider the following:

- Where is this code entangled?
- What modules are affected if this feature is removed?
- Could this part be replaced or removed later?

> **Deletability is a key indicator of maintainability and scalability, and we train this structural flexibility as part of our team culture.**

## 🧪 Mockup-Centric Thinking

> **The start of design is imagining how it will be used before full implementation.**

We value the habit of writing **mockup (mock) code** before actual implementation.  
Imagining how a function will be called, what results are expected, and in what context the feature will be used helps to design responsibilities and boundaries more clearly.

This approach has the following effects:

- Defines how the caller wants to use it first
- Filters out overly complex structures in advance
- Enhances the clarity and consistency of interfaces

> **Don't start by writing code, but by sketching how it will be used. This is what we call 'mockup-centric thinking'.**

## 🔗 Clear Call Interfaces

> **When calling a function or method, it shouldn't prompt the question, 'What does this code do?'**

A good interface doesn’t hide the code's complexity but simplifies the context and facilitates collaboration, being essential in design.

We consider the following important:

- Predictable inputs and outputs
- Functions that carry only one responsibility
- Names that make the context understandable at a glance

> **A clear call interface is the starting point of collaboration.**

## 🧠 Naming that Understands the Domain

> **Names are the first read manual in the code.**

We believe that the names of variables, instances, functions, and classes should explain **what role the code plays**.

We adhere to two principles:

1. **Name with at least two words**
   - Instead of names like `data`, `obj`, use domain-contextual names like `userProfile`, `paymentResult`.

2. **IDE is our tool.**
   - In environments with autocomplete, long names are not an issue.
   - They rather create a structure that is advantageous for searching, tracking, and collaborating.

> **Good naming is a trace of domain understanding and the first step in organizing the team's language.**

## 📝 Consider the Reader When Documenting

> **Documentation is not an explanation but a consideration.**

We value naturally conveying the reasons for decisions, choices made, and problems solved through **structure and naming** over comments.

We prioritize the following over comments:

- Explaining the context through the code’s structure and naming
- Making the flow understandable through function names, file organization, and separation of responsibilities
- Recording complex decisions in wikis, PR descriptions, READMEs, etc.

> **If the code itself reads well, that is the best documentation.**

## 📆 Readability with Maintenance in Mind

> **Good code is judged not now, but when it is maintained later.**

It’s more important that code can be modified by someone else **6 months, 1 year from now** than today.  
We see readability not just as a style but as a standard for sustainability and collaboration.

Characteristics of good code:

- Roles are separated and overlap is minimal
- Naming explains the domain context
- Intentions and reasons for decisions are preserved

> **"Can another developer understand and modify this code at first glance?"  
If the answer is yes, then it’s a success.**

## 🍝 Complex Code Requires Effort to Explain

> Complex code itself is not the problem.  
> **The problem is leaving it unexplained.**

Anyone can write **spaghetti-like code** while responding quickly or handling complex domains.  
We don't prohibit such code.

However, if such code remains within the team, **the effort to explain the reasoning and decisions at that moment** is absolutely necessary.

What’s important is not **perfect documentation**.

The developer's  
- Few lines of comments
- PR description
- Wiki link
- A line in README
- Meaningful variable or function names

**Any 'attempt to explain' itself is a sign of that person’s willingness to grow and an attitude of consideration for the team.**

We train to leave explanations anywhere, like PR descriptions, wikis, READMEs, comments, and make that part of our team culture.

> **Spaghetti code with explanations is a technical judgment.  
Spaghetti code without explanations is technical debt.**

---

# 3. What’s Left Behind Matters More Than Quantity

When performance starts to be judged by numbers, developers focus on creating many features quickly or writing more lines of code.  
But we know.

> **Doing a lot doesn’t mean doing well. What really matters is 'what has been left behind'.**

The simplest question to judge whether this code is good or not is this:
> **"Can a new person come, understand this code, and contribute to it?"**

If the answer is "yes," then the code is not just functional but has a structure that **preserves knowledge**, and it’s an output that contains **context and intent rather than quantity**.

---

## We do not base our judgment on:

- Number of commits
- Number of code lines
- Number of features
- Number of repeated modifications

## Instead, we base our judgment on:

- **Code that can explain intentions**  
- **Documents that reveal context**  
- **Structures considerate of the reader**

> **When these criteria are repeated, the evaluation becomes the language of the team.**

And we say:

> **If there is unexplained spaghetti code left, then perhaps that person has not yet understood what our team means by 'a good developer'.**

Because our team speaks through **outputs, not outcomes**.

We believe:

> **Regardless of the project, information should remain documented so that onboarding is possible anytime for anyone.**

The documents mentioned here don't necessarily have to be text.

- `README.md`  
- `docker-compose.yml`, `setenv.sh`, `Makefile`, `run.sh`  
- Initial DB schema, sample data  
- Mock APIs for front-end development  
- Shell commands for testing, seed files

**All these executable tools are onboarding documents, traces of our team's consideration, and our culture.**

And if nothing is left behind, we clearly state:

> **That person has not understood our team's culture.**

We are not a team that shares knowledge.  
**We are a team that makes knowledge survive.**

---

# 4. Evaluation Structure: A Trainable 3-Stage Process

We have designed the evaluation not as a judgment on results but as a **training process to internalize team culture and promote growth**.

## Summary of Evaluation Stages

| Stage | Participant       | Purpose                     | Key Question |
|------|------------|--------------------------|------------|
| 1st Stage | Self-evaluation   | Self-reflection based on standards   | “Am I working this way?” |
| 2nd Stage | Multifaceted evaluation   | Empathy and feedback on team standards | “Is my colleague working this way?” |
| 3rd Stage | Team leader judgment   | Assessment of domain relevance and practical contribution | “Was this code appropriate for the actual business?” |

---

## 🪞 Self-Evaluation – The Start of Internalization

- Developers reflect on whether their work aligns with team standards  
- Not just listing results, but a **self-check focused on intentions and context**

## 🤝 Multifaceted Evaluation – A Time for Empathy and Confirmation

- A process where **peers exchange feedback on standards**  
- Sharing how much each execution resonates with the standards

> **Multifaceted evaluations should not be formally reflected in evaluations.**  
> This process is a tool for checking the degree of cultural internalization.

- It’s not a means for comparison or ranking  
- It can even destroy trust if not handled properly, so **if the culture is not yet established, it must be boldly abandoned**

> **Multifaceted evaluation is a tool for training and empathy, not a formal criterion.**

This process is used **only to check the degree of cultural understanding and standard internalization** within the team.  
It is not a tool for comparison or ranking.

If not clearly recognized, multifaceted evaluation can **damage rather than build trust**.  
That’s why we educate all team members that **“multifaceted evaluation is a tool for empathy and training”** and repeatedly train in this.

## 🎯 Team Leader Judgment – Interpreter of Business Relevance

- **Qualitatively assesses domain relevance and practical contribution**  
- The team leader or leader checks **how much the outputs align with the business objectives**

Through these three stages,  
we believe we can **repeatedly train qualitative standards without quantitative comparison**.

> **Performance should be revealed not by results, but by understanding and executing standards within the process.**

---

# 5. Tools and Structure Used

No matter how good the evaluation criteria are,  
if there is no structure to **record, repeat, and review these standards**,  
it’s difficult to establish them as a culture.

We operate the team so that standards can **naturally be recorded, shared, and accumulated** through the following tools and habits.

## 🛠️ We Do Not Review PRs

We do not follow the traditional PR cycle of creating features and then getting approval.  
We operate a **standard-check process for refactoring**.

This process is not a procedure to check code consistency.  
**It’s a structured conversation time to read the good developer standards defined by the team together and train those standards in the code.**

These standards are checked through questions like:

- Was this code designed considering **deletability**?  
- **Does it read naturally without documentation?**  
- Was it designed by first imagining its usage and through **mockup-centric thinking**?  
- For complex structures or implementations, **was no explanation omitted?**  
- **Is the domain understood, and are terms and naming aligned?**

We call this structure **'Refactoring Day'** and run it like a PR at the end of the sprint schedule.

> **We do not review PRs.  
We operate a process for refactoring.  
However, we utilize Git's PR feature as a means.**

After a Refactoring Day,  
- Traces of standard checks remain, and  
- Commits and PRs, exchanged comments, documented intentions  
**ultimately accumulate as important outputs.**

These records are not mere work histories but **intellectual assets containing the team's thought processes, domain judgments, and technical contexts.**

In this structure, there is no longer an 'approver'.  
It’s not important who approves and who gives feedback, but **the process itself of each person checking the code according to the standards and recalling those standards becomes the team culture.**

> As self-review becomes possible, the standards are no longer external feedback but **become internalized habits.**

This repetition eventually makes the entire team **a trained group that can produce good code without needing approval.**

## 📘 Knowledge Base (Wiki, Notion, etc.)

- Organizes and summarizes domain understanding and decision-making flows derived from PRs, meetings, and retrospectives  
- Acts as a central hub for organizing and sharing team standards  
- **The more records there are, the clearer the team’s standards become**

## 🪞 Self-Evaluation & Retrospective Template

- Helps structure self-reflection and training on standards  
- Allows standards to **become internalized** through repeated execution  
- Used as a **reminder and training tool**, not for evaluation purposes

## 🧠 Team Leader Assessment Sheet (Qualitative Evaluation)

- Focuses on **domain relevance, practical use, and output completeness** rather than numbers  
- Evaluates based on business contribution and execution traces revealed in outputs  
- **A system that lets code and records speak, not people**

> We do not see these tools as evaluation tools.  
> **We see them as structures that allow the team to repeat and train the way they work.**

# 6. Conclusion: Designing Accumulation Over Evaluation

We do not want to use evaluation to rank people.

> **We agree on a common standard for what makes a good developer**, and based on that standard, **we create a structure that allows the team to grow on its own**.

Performance should be verified not by numerical results but by outputs containing **intentions of judgment and domain understanding**.  
And these outputs must remain as **traces accumulated in the team through PRs, documentation, reviews, and retrospectives**.

## This is how we work

- First, define the standards  
- Create a trainable structure  
- Design a reliable review culture  
- Internalize standards through repeated execution

> **A good team does not need evaluation.**  
> Within a structure where standards accumulate as culture, the team naturally produces good developers.

This is why we designed evaluation, how we operate the team, and how the culture works.