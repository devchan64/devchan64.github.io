---
date: 2025-04-22
permalink: /en/2025/04/22/commit-cannot-onboard.html
tags:
- Onboarding
- Knowledge Base
- Leadership
- Organizational Culture
title: Onboarding Doesn''t Happen Through Commits — Why Knowledge Disappears in
  Startups
---

> `gpt-4-turbo` has translated this article into English.

---

# Onboarding Doesn''t Happen Through Commits — Why Knowledge Disappears in Startups

---

# 1. Starting Point: The Absence of Knowledge Management

In startups, code and features quickly accumulate. 
But where is the knowledge accumulating?

Documentation always gets pushed to the *next step*. 
And eventually, someone says:

> “I left it in the commit.”

This is not merely a choice. 
In fact, it's because *we have not established a way to structure and convey knowledge*. 
Wikis are neglected, Notion becomes cluttered, and Confluence is too cumbersome to access easily. 
Eventually, developers begin to use **code commits and PRs as repositories of knowledge**.

On the surface, it might seem like there isn't a problem. 
After all, code is the most accurate truth, and commits contain all the history of changes.

However, the problem is not just about the **existence of information**, but about the **accessibility, connectivity, and contextuality of information**.

Commits may serve as "physical storage" of information, but they are not in themselves a **structure for knowledge transfer**.

> Knowledge must ultimately be shared to have meaning.  
> And commits can just be an **unintentional archive** producing *unshared information*.

---

# 2. Commits Store, But Do Not Transmit

Some developers pour deep affection into their commit messages.  
They include the background of feature changes, the impact on systems, test results, and even considerations of the business domain.

> `refactor: reduce query overhead by rewriting join logic in report generation`  
> `context: this is due to S3 sync lag during Q2 load testing, see incident #241`

Such structured and responsible commits are certainly excellent records.  
However, over time, these records become **monologues that no one looks for**.

Why is that?

## Unsearchable

Commit messages remain as logs within Git, but they are not exposed in the usual knowledge search flow.  
Developers first search Stack Overflow, Wiki, Notion, Slack, rather than opening `git log`.  
Thus, commits exist but are **not discovered**.

## Unstructured

Commits are listed chronologically.  
However, knowledge should be accessed in a **contextual order**.  
The context of a feature's inception, the choice of API structure, performance optimization must be conveyed in a **topic-centric structured form**.

## Unlinked

Commit messages cannot be hyperlinked.  
A commit that is not linked to a PR, Wiki, or document remains an **isolated record**.  
Knowledge gains meaning when linked, and flows enable onboarding and retrospectives.

## Uninterpreted

Code and commits are truths, but **without someone to interpret that truth, it is meaningless.**  
Records left without explanation, asking "Why was this commit written this way?", end up as isolated legacies.

Commits may technically contain a perfect history of changes, but  
**they do not function in the context of knowledge transfer.**

> As a result, no matter how carefully written, commits eventually become **knowledge that does not recover over time**.

---

# 3. PRs Ultimately Share the Same Fate

PR (Pull Request) is a core tool for collaboration within a team.  
It documents the design intent and implementation, enriches quality through discussions with reviewers, and  
ultimately formalizes changes.

However, in startups where change is rapid and staff frequently turnover,  
even PRs can degrade into **disposable communication tools rather than records**.

## PRs Are Forgotten Once Merged

Many PRs conclude like this:

> "LGTM"  
> "I'll merge this!"  
> (And it ends)

The PR body is full of intent, alternatives, considerations, but  
**no one reopens that PR later**.

## PR Context Is Not Preserved

While PRs are excellent tools for short-term review and feedback,  
they are not suitable for long-term onboarding or design retrospectives.

- PRs are divided by **feature units**
- Reviews focus only on **the context at that moment**
- The records are **not converted into documentation**

As a result, months later, this PR can't explain "what was implemented and why," becoming nothing more than a  
**bundle of merged commits**.

## Repository Becomes No Man's Land

In startups, it's common for developers who initially created a repository to leave the team.  
From that moment, the repo essentially becomes a **space without an owner**.

- Remaining commits and PRs are uninterpreted  
- New team members re-contemplate the same issues  
- The original design intent is treated as "done for unknown reasons"

Consequently, **knowledge stored in PRs becomes not a living document, but a neglected old book**.

> **PRs are not pathways for knowledge transfer.**  
> PRs are temporary review flows, and **structuring afterward is essential** for knowledge transfer.

---

# 4. Without a Structure for Knowledge, Onboarding Is Painful

When a new developer joins a startup team, the first obstacle is the **lack of documentation**.  
Without documents, they must search through commits and PRs, and if that fails, ask around.

This leads to:

> “Why was this designed this way?”  
> “Hmm... you might find something in a PR from four months ago…”  
> “The person who wrote that is no longer here.”

This is not onboarding but **digital archaeology**.

## Onboarding Documents Become 'Exploration' Not 'Experience'

Well-structured onboarding documents should serve as *entrances to knowledge*.

- Why was this system created this way?
- What is the historical context behind this feature?
- What alternatives were there, and why was this design chosen?

However, this information is mostly scattered.  
PRs, commits, meeting notes, Slack messages...  
**Traces of decisions exist, but no connected flow.**

Therefore, onboarding becomes not a single stream but a  
**puzzle game of assembling scattered pieces**.

## Without Sharing History, the Same Decisions Are Repeated

New personnel, not having shared the historical context,  
**will reconsider the same issues that the previous team deliberated.**

- Propose structures that were already abandoned
- Re-analyze problems that were already solved
- Repeat approaches that already failed

This soon becomes **a decline in organizational productivity and a regression in technical decisions**.

> **The pain of onboarding arises not from a lack of documentation, but because knowledge is not structured.**

---

# 5. Why Does Knowledge Disappear

We did record it.  
In commit messages, PR descriptions, and intermittent meeting notes…  
Yet, as time passes, no one remembers any of it.

**Why do we lose knowledge even though we stored it?**

## 1. Knowledge Is Accessed by 'Context', Not by 'Chronology'

Git lists history chronologically.  
But people do not think this way.

- I want to know 'why this feature is the way it is',
- Not 'who made what commit three months ago'.

Knowledge must be woven around functional units, domain units, decision units to have meaning.  
**Time is a standard for storage, not for transmission.**

## 2. Knowledge Must Be 'Interpreted', Not Just 'Recorded'

Even if records remain in commits or PRs,  
if they are **not interpreted, they are not knowledge.**

- If not structured into documents
- If not linked to onboarding guides
- If not appearing as answers to questions

Then practically, those records are *as good as gone*.

## 3. There Is No 'Owner' of Knowledge

In startups, owners often change, and  
repository ownership can become blurred.

As a result:

- No one knows who designed it or why
- When issues arise, there's no one to interpret the structure
- What remains is an uninterpretable record

**It's not the loss of records, but the absence of interpreters** that  
is the fundamental cause of knowledge loss.

> Knowledge is not effective just by merely 'existing'.  
> **It must be searchable, connected, and interpretable**  
to truly be an asset to the organization.

---

# 6. What Must We Change

To prevent the loss of knowledge, we need to change not just how we record, but **the flow and structure after recording**.  
Simply saying “let’s document well” won’t change things.  
**Designing a flow that allows knowledge to actively circulate within the organization** is necessary.
This is not the answer, but a direction to consider.

## A. Create a Flow of Knowledge

Knowledge is not completed in one go.  
**Commit → PR → Architectural Decision Record (ADR) → Wiki → Onboarding Document**  
It's important to have a multi-stage flow.

Each stage has roles like:

- **Commit**: Store the fact of change
- **PR**: Discuss the intent and details of the change
- **ADR**: Reasons for decisions, alternatives, and forsaken choices
- **Wiki/Notion**: Long-term structured transmission
- **Onboarding Document**: A guide for those new to the system

This flow doesn’t need to be perfect.  
What matters is whether there’s a “**structure to convey information to its users**”.

## B. Introduce a Culture of Structured Record-Keeping

- Include “design intent / alternatives / related commit links” in the **PR template**.
- Write **ADR (Architectural Decision Record)** in text and link it in the Wiki.
- Introduce **GPT summarization tools or automatic documentation tools** to reduce repetitive costs.

What’s important is considering structures that make **knowledge 'easy to write'**.  
Without assuming long-term transmission, no one will document consistently.

## C. Designate Organizational Owners or Roles

Saying “**knowledge is everyone’s responsibility**” is true but not practical.  
**If no one takes responsibility, no one will do it.**

Therefore, we need approaches like:

- Assigning owners per repository/domain (managing design/documents/onboarding)
- Adding a “knowledge transfer check” at the end of sprints
- Operating a “design retrospective / document refactoring week” quarterly

These efforts don’t lead to immediate results but are crucial for  
**preventing knowledge leakage and enhancing team sustainability**.

Startups need to move fast.  
But an organization that moves fast without knowledge will **keep making the same mistakes and not progress**.

> **The speed of knowledge is determined by the depth of records.**

---

# 7. Closing Message

We often postpone structuring knowledge because we are busy,  
or because we believe it’s already captured in the code.

However, knowledge is not just about being *recorded*;  
**it must survive within a structure**.  
That structure needs to be searchable, connectable, and interpretable for newcomers.

## Records Forgotten Are as Good as None

No matter how carefully crafted the commit,  
no matter how lively the PR discussion,  
as time passes, all are forgotten.

For that record to survive,  
for that knowledge to drive the organization,  
**it must move from record to structure, and from structure to flow**.

## More Dangerous Than Technical Debt — Knowledge Debt

Technical debt can be repaid through refactoring.  
But knowledge debt, once records are lost, is irreversible.

- Unable to interpret past intentions, the same discussions are repeated
- Fear to touch ownerless code
- Development pace gradually slows

This transcends a mere productivity issue and  
**threatens the entire organization's ability to learn and sustain itself.**

> Commit stores code, but structure stores knowledge.  
> Untransmitted records are merely lost design intentions.

---