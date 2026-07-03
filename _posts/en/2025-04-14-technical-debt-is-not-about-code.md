---
date: 2025-04-14
layout: post
permalink: /en/2025/04/14/technical-debt-is-not-about-code.html
tags:
- Organizational Culture
- Technical Debt
title: Technical Debt Is Not a Technical Problem
---
> This article was translated from the original Korean source. The English version was regenerated from the latest Korean document.

---

# Technical Debt Is Not a Technical Problem

> If technical debt is accumulating, it is not first a problem for the engineering team.  
> It is something HR and leadership should examine first.  
> Technical debt is not mainly a problem of code. It is a problem of how an organization treats technology.

---

Many organizations use the term "technical debt."  
But the phrase often functions as a way to shift all responsibility onto the engineering team.

That framing is deeply problematic.  
Technical debt certainly exists, but its causes do not exist only inside technology.

**The phrase easily misleads people into thinking that the cause exists inside engineering itself.**  
In reality, most technical debt starts before code is written: poor decisions, failed schedule management, and the absence of strategy.  
Its real starting point is often an unreasonable business demand or a lack of understanding of technology.

Even so, the term is often treated as if the engineering team alone must bear the burden.  
The real issue is not technology itself, but **the way the organization sees technology and the culture by which it makes decisions**.

> **Technical debt is not produced by technology itself. It is produced by decisions that ignored technology.**  
> Even so, many organizations reduce it to an engineering problem and avoid managerial accountability.  
> In that sense, the phrase "technical debt" becomes a linguistic device that enables quiet responsibility avoidance.

This article **criticizes the structural responsibility avoidance built into the term technical debt** and argues that technical debt should be redefined not as an internal engineering-management issue, but as **something the entire organization must jointly own and manage**.

---

# Technical Debt Is Unavoidable, but It Can Be Reduced

Technical debt is real. Every organization will produce some amount of it.  
But **how much debt gets created is entirely an organizational choice**.

People often say, "Technical debt can be managed."  
But that expression can make technical debt sound like something that can be tolerated flexibly.

> Technical debt is not simply something to "manage."  
> It is **an outcome that should be minimized as much as possible**.  
> Saying "it can be managed" can turn debt into something that feels acceptable.  
> Technical debt must be reduced and must never be left alone.

Much of the technical debt we see in practice **could have been prevented in the first place**.  
The root problem is not technology itself, but a culture of unreasonable schedules, vague decision criteria, and repeated disregard for refactoring time.

The purpose of this article is to move beyond the idea that technical debt is merely **an internal management responsibility of the engineering team** and reinterpret it as **the result of the organization's broader decision-making structure and culture**.

> We must remember one thing.  
> **Debt is something that must eventually be repaid.**  
> Technical debt that is not handled now returns later as much larger cost and risk.

---

# Types and Nature of Technical Debt

Technical debt is not a single problem.  
On the surface it may look like poor code quality, missing tests, or weak design.  
But if you follow the root cause, you almost always arrive at **organizational decision-making and leadership responsibility**.

Below are eight representative forms of technical debt and the ways they connect back to organizational problems.

---

## 1. Underengineering

### Definition

This refers to a state in which implementation-driven development happened without sufficient design, resulting in unclear boundaries and weak abstraction.

### Organizational Causes

- A schedule-driven culture that rewards speed above all else
- Lack of experience in architecture and structural design
- A habit of not recognizing design quality as something worth evaluating

### Solution Philosophy

- Interface design should be sketched first through mock code
- Reuse and adoption of design patterns should become part of engineering culture
- Structure should be defined before code

### Practical Understanding

Many organizations treat design as difficult and time-consuming.  
But structure is not a mystical concept.  
**Structure is the work of establishing a frame**, and at minimum it should include:

- What data will be exchanged, meaning interface modeling
- Which logic runs in which scenario, meaning business flow definition

This is less about adding new work and more about **changing the order of work**.  
At this level, TDD and up-front design do not meaningfully damage schedule speed.  
Clear structure usually improves the overall efficiency of development.

### Key Sentence

> Technical debt does not appear unless development happens.  
> So if development happens, it needs to be done properly.

---

## 2. Overengineering

### Definition

This refers to a state in which the organization introduced a design so complex and excessive that it could not realistically maintain or spread it, and the result became an unsustainable system.

### Organizational Causes

- Overdesign caused by excessive pursuit of technical perfection
- Obsession with ideal structures disconnected from reality
- Technology choices made without considering maintainers or operational capacity
- Lack of maintenance systems after design, including documentation, training, and infrastructure support

### Solution Philosophy

- If the organization cannot maintain a design together, it should not adopt it
- Technology choices should consider not only functional completeness but also team capacity, lifecycle, and transferability
- Complex design matters only when the organization can document it, share it, and build shared understanding around it

### Practical Understanding

Overengineering is not simply "well-crafted structure."  
If the organization cannot understand it or maintain it, **it is not a technical asset. It is technical debt**.

The moment the original owner leaves, or the next developer cannot understand the structure well enough to maintain it,  
that sophisticated design stops being an asset and becomes organizational risk.

Design is not about making something as elaborate as possible.  
It is about **creating boundaries the organization can maintain and transmit together**.

### Key Sentence

> Overengineering eventually becomes technical debt because no one is left to maintain it.  
> That is an HR failure and a leadership responsibility.

---

## 3. Documentation Debt

### Definition

This refers to a state in which documentation about design intent, system context, or usage has gone missing or was never created, reducing collaboration, maintenance efficiency, and onboarding quality.

### Organizational Causes

- Seeing documentation as a waste of time
- Not treating documentation as recognized output
- Failing to review the existence and quality of documentation in code review or QA
- No systematic documentation for onboarding

### Solution Philosophy

- Comments are not mere explanation. They are **notes for your future self**
- Interface-first mock code can itself function as structural documentation
- Readable code is explainable code, and clear code becomes better documentation immediately
- Writing documentation is productive work, and people who do it should be treated as **contributors**

### Practical Understanding

Many developers find documentation difficult.  
As a result, they often replace it with slide decks or one-off explanation sessions.  
That is neither efficient nor sustainable.

**Good code should be self-explanatory**, and in most cases clear and predictable code is more valuable than merely clever code.

In modern systems, simplifying structure for readability or clarifying flow rarely causes performance damage severe enough to justify obscurity.

That is why developers should keep the following principle:

> **Avoid fancy code.**

Good code has characteristics like these:

- A structure from which the full flow can be inferred
- Beauty that comes from clarity rather than complexity
- Intuitive function names and interfaces that need little commentary
- Separation of responsibility that makes modification and extension natural

Documentation is not just text.  
It is **a structured expression of knowledge that an organization can remember, maintain, and share together**.  
And it is preserved not by "good writers," but by people who continue writing and maintaining it.

### Key Sentence

> Documentation is not writing. It is culture.  
> Developers who document are the ones sustaining the company.

---

## 4. Testing Debt

### Definition

This refers to a state in which tests are excessive or badly designed, freezing the structure of the system and making refactoring and improvement harder instead of easier.

### Organizational Causes

- A culture that turns coverage numbers into goals
- Repeatedly writing unit tests without prior structural design
- Frequent interface changes with no clear criteria for change
- Not recognizing test refactoring as meaningful work

### Solution Philosophy

- Tests should be **walls that protect interfaces, not prisons that trap implementations**
- Mock code should be used to design interfaces first, and tests should follow that structure
- Interfaces should not change lightly, and if they do, the reason should be explicit
- Test design is also design work and should be reviewed as such

### Practical Understanding

Many organizations assume testing debt comes from not having enough tests.  
In practice, the problem is usually direction, not quantity.

Rather than testing implementation details as they are,  
**tests should be designed around interfaces and usage flow**.

More tests do not automatically mean safer code.  
Tests built on unstable structure can make refactoring harder and can actively block improvement.

The real issue is not whether tests exist, but **what the organization has agreed to test and by what criteria**.

### Key Sentence

> Tests are walls that protect structure, not prisons that block freedom.

---

## 5. Dependency Debt

### Definition

This refers to a state in which the system becomes trapped in a specific tool, framework, or pattern because of excessive dependence on external technology, making replacement or expansion difficult.

### Organizational Causes

- Adoption decisions made without considering a technology's lifecycle
- Inappropriate use of design patterns
- No transition strategy when introducing technology
- Depending on individual preference or experience instead of documented reasoning

### Solution Philosophy

- Replaceability should always be a baseline design principle
- Every technology should be introduced on top of **a structure that allows eventual exit**
- Technology choices should consider lifecycle, available maintainers, and future migration scenarios
- Technology choice is not an individual taste issue. It is an organizational responsibility and a leadership judgment

### Practical Understanding

Technology selection is often treated as a developer preference area.  
But the structure that introduces and sustains that technology is entirely **an organizational responsibility**.

Every technology eventually reaches a point where it must be replaced.  
The important question is whether it was designed to be replaceable.

**A structure that cannot be replaced is no longer just debt. It is a prison.**  
From the first moment of selection, the organization should create **an escapable structure, documented criteria, and a collaboration model others can inherit**.

### Key Sentence

> If it cannot be replaced, it is not debt. It is a prison.  
> Technology selection is not code-level taste. It is a strategic organizational decision.

---

## 6. Infrastructure Debt

### Definition

This refers to a state in which essential operating foundations such as CI/CD, monitoring, log collection, and test automation are weak or missing, reducing operational efficiency and incident response capability.

### Organizational Causes

- A culture that prioritizes quick feature delivery and initial convenience
- Failure to establish a DevOps culture
- Choosing business features over infrastructure cleanup
- Avoiding investment in operational automation

### Solution Philosophy

- Infrastructure debt is not mainly a technical limit. It is **something that exists because it was never executed**
- Regular inspection and cleanup should be part of the operating process
- Reliability and operational response should be recognized as **an organizational value greater than short-term feature output**

### Practical Understanding

Infrastructure debt usually does not come from ignorance.  
It comes from **knowing what is missing and continually leaving it below the priority line**.

But over time, this debt slows development and eventually causes serious problems in incident response and quality maintenance.

Fortunately, infrastructure debt is usually visible in a concrete way.  
**It is often the debt of something simply not done yet.**

That makes it less a question of technical limitation and more a question of **execution and organizational will**.  
If system health matters, infrastructure improvement is not optional.

### Key Sentence

> Infrastructure debt is not a problem of technology. It is a problem of execution.  
> If it has not been done, start doing it now.

---

## 7. Knowledge Debt

### Definition

This refers to a state in which critical knowledge about the system or work is concentrated in a small number of people, exposing the entire organization to risk when those people leave or become unavailable.

### Organizational Causes

- A culture that leaves behind commits but not organized knowledge
- Missing or neglected onboarding documentation and internal wikis
- Treating documentation and education as non-productive work
- Not properly evaluating developers who document and teach

### Solution Philosophy

- Documentation is not just a record. It is **a core asset that keeps the organization functioning**
- Organizing knowledge is long-term contribution, not clerical overhead, and it requires periodic refactoring too
- Onboarding documents, system overviews, and API guides should be recognized as **official deliverables**
- Leadership must treat documentation and knowledge sharing not as optional roles, but as **organizational responsibilities**
- Preserving knowledge only in commits is proof that the organization has not yet found a better way to manage knowledge. Commits do not onboard people. That needs to improve

### Practical Understanding

Many developers say this:

> "Writing code and making commits is already enough. Keeping documents organized is hard."

That is realistic.  
But repeated difficulty is not a reason to tolerate knowledge discontinuity.

Organizations should therefore treat knowledge debt not as a personal weakness, but as **a structurally solvable problem**.

- If onboarding documents are systematically maintained
- If system flow is shared
- If knowledge transfer happens during review and retrospectives

Then knowledge debt can be managed effectively.

The biggest lever is still **a change in leadership perception**.

> **Developers who write documents are the people who leave something behind for the company.**  
> That recognition alone can sharply reduce the rate at which knowledge debt appears.

### Key Sentence

> Knowledge debt is not a technical problem. It is a perception problem.  
> Developers who write documents are the ones sustaining the company.

---

## 8. Decision-Making Debt

### Definition

This refers to a state in which decisions made without understanding technical context or structural impact make the system inefficient or overdesigned, producing repeated refactoring and structural distortion.

### Organizational Causes

- Decisions made without technical understanding
- Schedules and feature requests defined while excluding technical perspective
- Weak authority for CTOs or technical leaders in actual decisions
- Strategic decisions made without technical counsel

### Solution Philosophy

- Technical decisions must be made by people who **understand the technology**
- Before blaming developers, decision-makers must bear **organizational responsibility** for the consequences of their decisions
- Technical decisions should remain in the organization as **explainable and shareable structure**
- The technical literacy of decision-makers should be reflected explicitly in evaluation criteria

### Practical Understanding

One question appears often during retrospectives after debt has accumulated:

> "Why did we decide that back then?"

In many cases, the answer is simple: **the decision was made without technical context**.  
The result is structural inefficiency, repeated refactoring, and a cycle of responsibility avoidance.

That is not a developer failure.  
**It is an outcome produced by the organization's structure, HR system, and leadership mindset**.

A decision made without real understanding of technology is not just a mistake.  
It becomes organizational risk.

### Key Sentence

> Technical debt is not a developer failure. It is a failure of the decision-making structure.  
> When people who do not understand technology decide technical matters, it becomes a management risk.

---

# Technical Debt Is Prevented Through Culture

Technical debt is not solved simply by rewriting code.  
Unless **the way the organization handles technology** changes, the debt will return.

There is no need to introduce a brand-new framework or tool in order to reduce technical debt.  
The more important work is:

- changing the perspective and order of the development process itself
- changing how developers are perceived and evaluated

To prevent technical debt, the organization needs to establish the following **core practices** culturally.

## 1. Interface-First Development Based on Mock Code

- Model **flow and interfaces before implementation**
- This is not "extra work." It is just a different order of work
- Interface-first development makes **TDD, documentation, review, and refactoring** easier

## 2. A Code Style Culture Centered on Readability

- Readable code is explainable code
- If the flow is clear, longer code is not automatically a problem
- If code becomes complex for performance reasons, that complexity must still be explainable

## 3. An Organization That Recognizes Documentation as Performance

- Documentation is organizational memory and the basis of collaboration
- People who write documentation should be treated as **contributors**
- Documentation quality should be reviewed and **recognized as formal output**

## 4. Review Is Not a Rule. It Is a Philosophy

- Review is not just bug finding. It is **time spent sharing design philosophy**
- Feedback should focus less on grammar or style and more on structure, flow, and responsibility
- Review criteria should be documented and shared across the organization

## 5. Technology Choices Must Consider Lifecycle and Organizational Capability

- Technology adoption should be judged not by novelty, but by **maintainability and replaceability**
- Technology choice is a strategic leadership decision that should consider **long-term structure rather than short-term convenience**

## 6. Knowledge Belongs to the Organization, Not to Individuals

- Knowledge is not preserved automatically. It is maintained through **deliberate organization and transfer**
- Onboarding documents, system structure explanations, and API usage guides should be treated as **formal deliverables**
- Knowledge contribution should be evaluated explicitly, and **that shift begins with management**

Technical debt emerges where culture is missing.  
The most effective way to prevent it is for **the organization to build a culture that respects technology**.

---

# Let’s Operate a Technical Debt Cleanup Day

Technical debt is unavoidable, and it accumulates.  
What matters is recognizing it and **checking and reducing it repeatedly through a deliberate routine**.

Cleaning up technical debt does not need to be dramatic.  
**A regular "technical debt cleanup day" is enough, as long as the team decides what to do with it.**

This is not a slogan. It is execution.  
That execution can take forms like the following.

---

## This Is What I Argue:

### 1. Write Documents That Explain Interfaces

- Explicitly record **how data flows are designed between APIs or internal modules**
- Even if no one else reads it today, **write it so your future self can understand it**

### 2. Interpret and Explain Spaghetti Code

- Analyze **how a tangled code structure came to exist in the first place**
- Record why the decision was made and **what constraints and decision-makers shaped it**

### 3. Explicitly Mark Items Recognized as Technical Debt

- Clearly declare and tag: **"This is technical debt."**
- Set a plan for **when it should be revisited**

### 4. Document a Deletion Scenario

- Technical debt must eventually be removed
- If it cannot be removed now, **document where deletion should begin and how it can proceed**

## This Is the Important Point:

> **A technical debt cleanup day does not have to be the day the debt is fully removed.**  
> **Preparation for cleanup is already enough.**

If the team has extra room on that day,  
additional work such as automation, test refactoring, or infrastructure checks can naturally follow.

## And This Is Where the Real Effect Begins

When this routine repeats and becomes habit,  
developers begin writing code with **a stronger sense of structure and responsibility from the start**.  
During review, the team begins to build **a culture that detects and coordinates technical debt before it grows**.

> In the end, a technical debt cleanup day is not mainly time spent fixing code.  
> It is time spent training culture.

The team becomes healthier,  
and the organization develops **a culture that takes responsibility for how it handles technology**.

---

# Conclusion: Technical Debt Reflects Responsibility

Technical debt remains in code.  
But the choices that produced it usually came from **outside the code**, from **organizational judgment and structure**.

On the surface it may look like something the engineering team should own alone,  
but in reality it is **the result of organization-wide decisions and culture surrounding technology**.

Decisions made without technological understanding,  
choices of structures that cannot be replaced,  
schedules forced forward without refactoring time...

These are not failures of technology.  
They are **failures in how the organization treats technology**.

That is why technical debt is not just an engineering problem.  
It is **something the entire organization should own and solve together**.

## And in truth, reducing technical debt is not that complicated

> **If the organization practices just the following four things, technical debt will fall visibly.**

### 1. Encourage Writing Mock Code

- Design the interface first and place structure before implementation

### 2. Encourage Readable Code

- Build a culture that values readability and clarity first

### 3. Leadership Should Admit Its Own Technical Limits

- Technical judgment should be delegated to technical people, while leaders should ask, learn, and listen

### 4. Recognize the Practitioners Who Protect Technical Culture

- Documentation, review, testing, and refactoring should all be recognized as formal contributions

These actions are not grand strategy.  
They are **small shifts in organizational attitude that show respect for technology**.

## The Way to Solve Technical Debt Is Simple

Operate a regular "technical debt cleanup day"  
and simply decide together **what will be handled on that day**.

- organize interfaces
- explain complex code
- document deletion scenarios
- tag technical debt explicitly

If these small routines repeat,  
**the team grows healthier, and the organization builds a culture that respects technology**.

---

# Technical Debt Is Not a Failure of Technology

Technical debt is  
**feedback about the attitude an organization has toward technology**.

And that feedback is  
**a responsibility the entire organization must answer, not the engineering team alone**.

---

# Appendix. My Classification and Philosophy of Technical Debt

# Classification of Technical Debt

### 1. Decisions That Skipped Process

- Examples: skipping tests, skipping documentation, skipping code review, not introducing automation
- Characteristic: decisions that skipped procedures intended to preserve stability and consistency
- Judgment: deliberate choices made to reduce time
- My philosophy:
  > This type is technical debt that can often be repaid through tools.
  > Automation, linting, and test templates can improve productivity and stability,
  > so I treat it as relatively low-interest debt that can be repaid over a longer horizon.
  > My approach is to prevent it early by putting tools into the design itself.

### 2. Decisions That Skipped Technical Validation

- Examples: launching without performance validation, designing structure without scale considerations, skipping architecture-fit evaluation
- Characteristic: decisions made without verifying technical foundations or structural stability
- Judgment: "let's just do it for now" decisions
- My philosophy:
  > This type is high-interest short-term technical debt that must be repaid.
  > I try to inspect structure quickly and divide the mitigation path into first-, second-, and third-stage repayment plans.
  > Even postponed decisions are a form of debt,
  > so my approach is to pair them with design that minimizes future shock.

### 3. Things Mistaken for Technical Debt

- Examples: a wrong structure chosen because of lack of knowledge, a simple technical failure, an operational misjudgment
- Characteristic: problems discovered later are wrapped as "unavoidable debt" even though they were really failure or ignorance
- Judgment: failure caused by ignorance or mistake is reinterpreted as if it had been an intentional deferral
- My philosophy:
  > This is not technical debt.
  > It is failed technical investment, failed decision-making, or structural ignorance inside the organization.
  > Technical debt arises only from **a choice made with the intention to repay it later**.
  > The moment failure gets packaged as technical debt, the organization starts justifying the problem instead of reflecting on it.
  > I think drawing that line clearly is extremely important.

## Closing Statement: My Operating Philosophy on Technical Debt

Technical debt is not created simply because technology was weak.
It is the result of responsibility tied to judgment and structure.
I believe technical debt should be prevented with tools, deferred judgment should be absorbed through design, and failure should be treated as failure in structural terms.
That is the operating philosophy I hold on technical debt.
