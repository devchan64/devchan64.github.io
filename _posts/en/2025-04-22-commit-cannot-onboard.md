---
date: 2025-04-22
permalink: /en/2025/04/22/commit-cannot-onboard.html
tags:
- Onboarding
- Knowledge Base
- Leadership
- Organizational Culture
title: Onboarding Doesn't Happen Through Commits — Why Knowledge Disappears in Startups
---
> `gpt-4-turbo` has translated this article into English.

---

# 1. Starting Point: Lack of Knowledge Management

In startups, code and features accumulate rapidly. 
But where is the knowledge accumulating?

Documentation always gets pushed to *the next step*. 
And eventually, someone says:

> “I left it in the commit.”

This is not a simple choice. 
In fact, it's because *we lack a way to structure and convey knowledge*. 
Wikis are neglected, Notion becomes cluttered, and Confluence is too cumbersome and inaccessible. 
Eventually, developers begin to use **code commits and PRs as a knowledge repository.**

It might seem like there is no problem on the surface. 
After all, code is the most precise truth, and commits contain all the history of changes.

However, the problem is not just about the **presence of information**, but about the **accessibility, connectivity, and contextuality** of information.

A commit may be a "physical storage" of information, but it is not a **structure for knowledge transfer** on its own.

> Knowledge only has meaning when shared.  
> And commits can just be an **unintended archive** producing *unshared information*.

---

# 2. Commit Stores, But Does Not Transmit

Some developers pour deep affection into their commit messages.  
They include the background of feature changes, impacts between systems, test results, and even considerations of the business domain.

> `refactor: reduce query overhead by rewriting join logic in report generation`  
> `context: this is due to S3 sync lag during Q2 load testing, see incident #241`

Such structured and responsible commits are certainly excellent records.  
But as time passes, these records become **monologues that no one looks for**.

Why is this?

## Unsearchable

Commit messages remain as logs within Git, but they do not appear in the regular flow of knowledge search.  
Developers first look up Stack Overflow, Wiki, Notion, or Slack, not starting with `git log`.  
Thus, the commits exist but are **undiscovered**.

## Unstructured

Commits are listed in chronological order.  
However, knowledge needs to be accessed in **contextual order**.  
The context of a feature's creation, API structure choices, and performance optimizations need to be **organized around topics** to be effectively conveyed.

## Disconnected

Commit messages cannot be linked.  
Commits that are not linked to PRs, Wikis, or documents through hyperlinks remain **isolated records**.  
Knowledge becomes meaningful when connected, and flows enable onboarding and retrospectives.

## Uninterpreted

Code and commits are truths, but **without someone to interpret these truths, they are meaningless.**  
A record left without anyone to explain the rationale behind a commit eventually becomes an isolated legacy.

Although commits technically contain a perfect history of changes,  
**they do not function in the context of knowledge transfer.**

> As a result, even the most diligently written commits become **forgotten knowledge over time**.

---

# 3. PRs Ultimately Face the Same Fate

PR (Pull Request) is a key tool for collaboration within a team.  
It formalizes changes through explaining design intentions and content, and enhancing quality via discussions with reviewers.

However, in startups where changes are rapid and staff frequently changes,  
even PRs can degrade to **disposable communication tools rather than records**.

## PRs Are Forgotten Once Merged

Many PRs conclude like this:

> "LGTM"  
> "I'll merge this!"  
> (And that's the end)

The PR body may be filled with intentions, alternatives, and considerations,  
but **no one reopens that PR later**.

## The Context of PRs Is Not Preserved

PRs are great for short-term reviews and feedback,  
but not suitable for long-term onboarding or design retrospectives.

- PRs are divided into **feature units**
- Reviews focus only on **the context at that particular moment**
- Records do not transition into **documentation**

As a result, months later, these PRs fail to explain "why something was implemented in that way" becoming merely a **bundle of merged commits**.

## Repositories Become No Man's Lands

In startups, it's common for the developer who initially created a repository to leave the team.  
From that moment, the repo effectively becomes a **space without an owner**.

- Leftover commits and PRs are not interpreted by anyone  
- New team members re-contemplate the same problems  
- The original design intentions are treated as 'done for some unknown reason'

Consequently, **knowledge stored in PRs becomes not a living document, but a neglected ancient text**.

> **PRs are not pathways for knowledge transfer.**  
> PRs are just a momentary review flow, and **structuring afterward is essential** for knowledge transfer.

---

# 4. Without a Structure for Knowledge, Onboarding Is Painful

When a new developer joins a startup team, the first barrier they encounter is the **absence of documents**.  
With no documents available, they must dig through commits and PRs, and if that fails, they must ask around.

This leads to scenarios like:

> “Why was this designed this way?”  
> “Hmm... you might find something in a PR from four months ago...”  
> “The person who wrote that is no longer here.”

This isn't onboarding; it's **digital archaeology**.

## Onboarding Documents Become 'Explorations' Rather Than 'Experiences'

Well-structured onboarding documents should serve as *an entry point to knowledge*.

- Why was this system created this way?
- What is the historical context behind this feature?
- What options were considered, and why was the current design chosen?

However, such information is mostly scattered.  
PRs, commits, meeting notes, Slack messages...  
**Traces of decision-making exist, but no connected flow.**

Thus, onboarding becomes not a single flow but  
**a puzzle game of assembling scattered pieces**.

## Without Sharing History, the Same Decisions Are Repeated

New personnel, who have not shared historical contexts,  
**will reconsider the same problems that the previous team contemplated.**

- They might suggest structures that were already abandoned
- They analyze problems that were resolved long ago
- They repeat approaches that failed

This leads to **a decline in organizational productivity and a regression in technical decisions**.

> **The pain of onboarding arises not just from a lack of documentation but because knowledge is not structured.**

---

# 5. Why Does Knowledge Disappear

We did record it.  
In commit messages, PR descriptions, and even sporadic meeting notes...  
But as time passes, no one remembers any of it.

**Why do we lose knowledge despite having stored it?**

## 1. Knowledge Is Accessed by 'Context', Not by 'Chronology'

Git lists history in chronological order.  
But that's not how people think.

- I want to know 'why this feature is the way it is',
- not 'who made what commit three months ago'.

Knowledge should be woven around functional units, domain units, decision-making units to truly make sense.  
**Time is a criterion for storage, not for transmission.**

## 2. Knowledge Must Be 'Interpreted', Not Just 'Recorded'

Even if records remain in commits or PRs,  
if they are **not interpreted, they are not knowledge.**

- If not structured into documents
- If not linked to onboarding guides
- If not appearing as answers to questions

Then practically, those records are *as good as gone.*

## 3. There Is No 'Owner' of Knowledge

In startups, ownership often changes, and
repository ownership can become unclear.

As a result:

- No one knows who designed it or why
- If issues arise, there's no one to interpret the structure
- What's left is an uninterpretable record

**The loss isn't due to the disappearance of records, but the absence of interpreters**  
is the fundamental cause of knowledge loss.

> Knowledge doesn't simply remain valid because it 'exists' somewhere.  
> **It must be searchable, connected, and interpreted**  
to truly be an asset to the organization.

---

# 6. What Must We Change

To prevent the loss of knowledge, we must change not just how we record, but also **the flow and structure after recording**.  
Merely saying "let's document well" won't change anything.  
**A flow that allows knowledge to live and move within the organization** must be designed.

## A. Create a Flow of Knowledge

Knowledge isn't completed all at once.  
**Commit → PR → Design Record (ADR) → Wiki → Onboarding Document**  
It's important to have a multi-stage flow.

Each stage has a role:

- **Commit**: Storing the fact of change
- **PR**: Discussing the intent and implications of changes
- **ADR (Architecture Decision Record)**: Reasons for decisions, alternatives, and choices abandoned
- **Wiki/Notion**: Long-term structured transmission
- **Onboarding Document**: A path for those at the entry point

This flow doesn't need to be perfect.  
What's important is whether a **"structure for delivering information to users"** exists.

## B. Implement a Culture of Structured Recording

- Include "design intent / alternatives / related commit links" in the **PR template**.
- Keep **ADR (decision records)** in text form and link them to the Wiki.
- Introduce **GPT summarization tools or automatic documentation tools** to reduce repetitive costs.

What's crucial is creating a structure that makes **knowledge easy to write**.  
Without a premise for long-term transmission, ultimately, no one will document.

## C. An Organizational Role or Responsibility Is Needed

The saying **"knowledge is everyone's responsibility"** is true but not practical.  
**If no one is responsible, no one will do it.**

Thus, the following are necessary:

- Appoint owners for repositories/domains (managing design/documents/onboarding)
- Add a "knowledge transfer check" phase at the end of sprints
- Operate "design retrospective / document refactoring weeks" quarterly

These tasks may not lead to immediate results, but they are **key structures for preventing knowledge leakage and enhancing team sustainability**.

Startups need to move fast.  
But an organization that moves fast without knowledge **ends up making the same mistakes and going nowhere**.

> **The speed of knowledge is determined by the depth of records.**

---

# 7. Closing Message

We postpone structuring knowledge because we are busy,  
or because we think it's already captured in the code.

However, knowledge doesn't just transmit because it's *recorded*.  
**Knowledge must exist within a structure**.  
That structure needs to be searchable, connectable, and interpretable by new people.

## A Record Not Remembered Is As Good As None

No matter how meticulously you craft a commit,  
no matter how lively the discussion in a PR was,  
as time passes, it all gets forgotten.

For that record to survive,  
for that knowledge to drive the organization,  
it must go from **records to structure, from structure to flow**.

## More Dangerous Than Technical Debt — Knowledge Debt

Technical debt can be repaid through refactoring.  
But knowledge debt, once records are gone, is irreversible.

- Repeating the same discussions due to an inability to interpret past intentions
- Hesitating to touch ownerless code
- Ultimately slowing down development

This moves beyond a mere productivity issue,  
threatening the **learning ability and sustainability of the entire organization**.

> Commits store code, but structures store knowledge.  
> Untransmitted records are merely forgotten design intentions.