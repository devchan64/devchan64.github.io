---
date: 2025-04-14
layout: post
permalink: /en/2025/04/14/technical-debt-is-not-about-code.html
tags:
- Organizational Culture
- Technical Debt
title: '"Technical Debt is Not a Technology Issue"'
---
> `gpt-4-turbo` has translated this article into English.

---

# Technical Debt: A Reflection for HR and Management

> If technical debt is accumulating, it is not just a problem for the tech team,  
> but a matter that HR and management should reflect on first.  
> Technical debt is not an issue with the code, but with how the organization handles technology.

---

Many organizations use the term "technical debt."  
However, this term often functions as a structure that shifts all responsibility onto the tech team.

I have deep concerns about this way of expression.  
Technical debt certainly exists, but its causes are not solely within the technology.

**This expression misleadingly suggests that the causes lie within the technology itself.**  
In reality, most technical debt originates from decisions made before coding, failures in schedule management, and a lack of strategy.  
These starting points often stem from unreasonable demands from the business unit or a lack of understanding of technology.

Nonetheless, this term is perceived as if the tech team must bear all the burdens.  
The essence of the problem is not technology itself, but **how the organization views technology and its decision-making culture**.

> **Technical debt is not a result of the technology itself, but of decisions made disregarding technology.**  
> Yet, many organizations limit this debt to the tech team, attempting to escape managerial responsibility.  
> Ultimately, the term "technical debt" becomes a linguistic device that enables quiet shirking of responsibility.

This article **criticizes the structural avoidance of responsibility inherent in the term 'technical debt'**,  
redefining technical debt not as an issue of tech team management but as a matter **that the entire organization should collectively be responsible for and manage**.

---

# Technical Debt is Inevitable, But Reducible

Technical debt is a reality. It inevitably arises at some level in all organizations.  
However, **how much debt is produced is entirely up to the organization's choice.**

It is commonly said that "technical debt is manageable."  
However, this expression can mistakenly make it seem like technical debt is a problem that can be flexibly accommodated.

> Technical debt is not merely a "management" issue,  
> but an **outcome that should be minimized as much as possible.**  
> The phrase "it can be managed" may lead to the misconception that technical debt is an acceptable option.  
> Technical debt must be reduced and never left unchecked.

In fact, much of the occurring technical debt could have been prevented from the start.  
The real issue lies not in the technology itself, but in the organization's culture of unreasonable schedules, unclear judgment criteria, and consistently ignoring refactoring time.

The purpose of this article is to move beyond viewing technical debt as solely the tech team’s management responsibility,  
reinterpreting it as a result of the **overall decision-making structure and culture of the organization**.

> We must always remember this point.  
> **Debt is something that must eventually be repaid.**  
> Technical debt not managed now will return in the future as much greater costs and risks.

---

# Types and Nature of Technical Debt

Technical debt is not a singular issue.  
While it may appear on the surface as degraded code quality, missing tests, or insufficient design,  
following its roots always leads to **the responsibility of organizational decision-making and leadership**.

Let us now examine how technical debt is linked to organizational issues through the typical eight types.

---

## 1. Underengineering

**Definition**  
Refers to a state where development is driven by implementation without sufficient design, resulting in a structure with unclear boundaries and lacking abstraction.

**Organizational Causes**  
- A culture focused on quick results and schedule-driven  
- Lack of experience in architectural design  
- Not recognizing structural design as an evaluative criterion

**Solution Philosophy**  
- Interface design should initially be implemented with mock code  
- Code reuse and adoption of design patterns should become part of the development culture  
- Structure should be defined before coding

**Practical Understanding**  
Many organizations perceive design as a difficult and time-consuming task.  
However, structure is not a complex concept.  
**Structure is about 'setting the frame'**, and should include at least the following elements:

- What data will be exchanged (interface modeling)  
- Which scenarios will operate which logic (defining business flow)

This is not about adding new tasks, but **simply changing the order of tasks**.  
This level of test-driven development (TDD) and upfront design does not negatively impact the schedule.  
Rather, a clear structure enhances overall development efficiency.

**Key Sentence**  
> Technical debt does not occur if development is not performed.  
> Therefore, if development proceeds, it must be done correctly.

---

## 2. Overengineering

**Definition**  
Refers to a state where the organization has introduced an overly complex and excessive design that it cannot maintain or propagate, leading to an unsustainable system.

**Organizational Causes**  
- Overdesign resulting from an excessive pursuit of technical perfection  
- Obsession with idealistic structures that are disconnected from reality  
- Choosing technologies without considering maintenance personnel or operational resources  
- Lack of a maintenance system after design, such as documentation, training, and infrastructure development

**Solution Philosophy**  
- Designs that the organization cannot maintain together should not be introduced  
- Technology choices should consider not only functional completeness but also the organization's manpower, lifecycle, and propagation potential  
- Complex designs only make sense in an organizational culture where documentation, sharing, and empathy are possible

**Practical Understanding**  
Overengineering is not "a well-made structure."  
When an organization cannot understand and maintain a structure, it becomes not a technological asset but a technical debt.

The moment a responsible person leaves or the next developer struggles with maintenance due to an inability to understand the structure,  
that complex design ceases to be an asset and instead becomes a risk to the organization.

Design is not about making something as sophisticated as possible, but about **creating boundaries that the organization can maintain and propagate together**.

**Key Sentence**  
> Overengineering eventually becomes technical debt as there is no one left to maintain it.  
> This is ultimately a failure of HR and a responsibility of leadership.

---

## 3. Documentation Debt

**Definition**  
Refers to a state where there is a lack of or missing documentation about design intentions, system context, and usage methods, leading to decreased overall development efficiency including collaboration, maintenance, and onboarding of new personnel.

**Organizational Causes**  
- Perception of documentation as a 'waste of time'  
- Not recognizing the writing of documents as a performance metric  
- Not reviewing the presence of documentation in code reviews and QA processes  
- Lack of systematic documentation for onboarding

**Solution Philosophy**  
- Comments are not mere descriptions, but **memos for the future self**  
- Interface-focused mock code can function as documentation itself  
- 'Readable code' is directly 'explainable code,' and clear code serves as effective documentation  
- Document writing is a productive act, and those who write documents should be treated as **contributors**

**Practical Understanding**  
Many developers find it challenging to write documents.  
Often, they prepare presentation materials or separate explanation sessions as substitutes.  
However, this is inefficient and not sustainable.

**Good code should be self-explanatory**, and it is more valuable to have clear and predictable code than technically superior code.

In the modern computing environment, simplifying structures or clarifying flows for readability seldom has a critical impact on performance.

Therefore, developers should embrace the following philosophy:

> **"Avoid fancy code."**

Good code has the following characteristics:

- A structure that allows the overall flow to be inferred from the code itself  
- Beauty that arises from clarity, not complexity  
- Intuitive function names and interfaces that do not require comments  
- A structure of responsibility that naturally accommodates modifications and extensions

Documentation is not just text.  
**It is an expression structured to preserve, maintain, and propagate knowledge together as an organization.**  
And this knowledge structure is maintained by those who **continuously write and manage it**, not by those who are good at writing.

**Key Sentence**  
> Documentation is not writing; it is culture.  
> Developers who write documents are the ones who sustain the company.

---

## 4. Testing Debt

**Definition**  
Refers to a state where tests are either excessive or poorly designed, solidifying the system structure and hindering rather than facilitating refactoring and improvements.

**Organizational Causes**  
- Setting test coverage figures as goals  
- The habit of repeatedly writing unit tests without structural design  
- Frequent interface changes and unclear criteria for changes  
- Not recognizing the refactoring of tests as a performance metric

**Solution Philosophy**  
- Tests should not be a prison that confines implementations but a wall that protects interfaces  
- Interfaces should be designed first using mock code, and tests should be written based on these  
- Interfaces should not change easily, and if changes are needed, the reasons must be clear  
- The design of tests is also part of the design process and should be subject to review

**Practical Understanding**  
Many organizations misunderstand that testing debt arises from a lack of tests.  
However, the problem actually stems from the wrong direction.

Instead of testing the implemented logic as is, **tests should be designed around the interfaces and their usage flows**.

Having many tests does not necessarily mean the code is secure.  
Tests built on unstable structures can make refactoring difficult and hinder improvements.

The key is not the existence of tests, but **organizational consensus and criteria on what and how to test**.

**Key Sentence**  
> Tests are walls that protect structures, not prisons that restrict freedom.

---

## 5. Dependency Debt

**Definition**  
Refers to a state where the system has become fixated on specific tools or patterns due to excessive reliance on external technologies, frameworks, or libraries, making replacement or expansion difficult.

**Organizational Causes**  
- Introduction decisions made without considering the lifecycle of the technology  
- Inappropriate application of design patterns  
- Lack of a transition strategy when introducing technologies  
- Dependence on personal capabilities or failure to document the basis for technology choices

**Solution Philosophy**  
- Always design with a replaceable structure as a basic principle  
- Any technology introduced should be on a structure that allows for easy exit  
- Strategic choices need to consider the technology’s lifecycle, maintainable manpower, and future transition scenarios  
- Technology choices should be the responsibility of the organization and the judgment of leaders, not based on personal preferences or experiences

**Practical Understanding**  
Technology choices are often regarded as the domain of interest for developers, but  
the structure in which the technology is introduced and maintained is entirely **the responsibility of the organization**.

Every technology will face a moment of replacement.  
What matters is whether that technology was designed to be replaceable.

**A technology structure that cannot be replaced is not just a debt but a prison.**  
From the moment of technology selection, the organization must ensure an **escapable structure, documented standards, and a collaborative framework**.

**Key Sentence**  
> If it cannot be replaced, it is not a debt but a prison.  
> Technology selection is not a matter of code but a strategic decision that the organization must handle.

---

## 6. Infrastructure Debt

**Definition**  
Refers to a state where essential elements for system operation such as CI/CD, monitoring, log collection, and test automation are inadequate or missing, leading to reduced operational efficiency and response capability in handling issues.

**Organizational Causes**  
- A culture that prioritizes initial development convenience and quick functionality implementation  
- Lack of establishment of a DevOps culture  
- Prioritizing business functions over addressing technical debt  
- Avoidance of investment related to operational automation

**Solution Philosophy**  
- Infrastructure debt is a problem that arises not because of technical issues, but because they were not implemented  
- Regular inspections and liquidations should be included in operational processes  
- The reliability and responsiveness of the operational environment should be recognized as **greater organizational value than feature development**

**Practical Understanding**  
Infrastructure debt usually does not occur because it is unknown, but rather  
because it has been deprioritized despite being known.

However, this debt slows down development over time and  
ultimately has a severe impact on incident response and quality maintenance.

Fortunately, infrastructure debt exists in a relatively clear form.  
**It is a problem that can be addressed by starting to implement what has not been done so far.**

This is not a matter of technical limitations but of **execution capability and organizational will**.  
Ensuring the health of the system makes infrastructure improvement not an option but a necessity.

**Key Sentence**  
> Infrastructure debt is not a problem of technology but of execution.  
> If it hasn't been done yet, it's time to start now.

---

## 7. Knowledge Debt

**Definition**  
Refers to a state where critical knowledge about the system or operations is concentrated in specific individuals, exposing the entire organization to risk if those individuals leave or are absent.

**Organizational Causes**  
- Leaving only code commits and omitting knowledge organization  
- Lack of or neglect of onboarding documents and internal wikis  
- Viewing documentation and educational activities as non-productive work  
- Not properly evaluating developers who perform documentation

**Solution Philosophy**  
- Documentation is not just a record but a **core asset for maintaining the organization**  
- Organizing knowledge is not just production but a long-term contribution that requires regular refactoring  
- Onboarding documents, system overviews, and API guides must be recognized as **official outcomes**  
- Management must recognize documentation and knowledge sharing not just as roles but as **organizational responsibilities**

**Practical Understanding**  
Many developers say:  
> "It’s hard enough to write code and commit; organizing documents is difficult."

This is a realistic statement.  
However, that difficulty should not lead to neglect of knowledge discontinuity.

Therefore, organizations should view knowledge debt as a problem that can be structurally resolved, not just an individual responsibility.

- If onboarding documents are systematically organized  
- If system flows are shared  
- If knowledge is transferred during review and retrospective processes

Organizations with such a culture and structure can effectively manage knowledge debt.

Above all, a change in management's perception is crucial.

> **Developers who write documents are those who leave a legacy for the company.**  
> This recognition alone can dramatically reduce the occurrence of knowledge debt.

**Key Sentence**  
> Knowledge debt is not a problem of technology but of perception.  
> Developers who write documents are those who sustain the company.

---

## 8. Decision-Making Debt

**Definition**  
Refers to a state where decisions made without understanding the technical context or structural impact render the system inefficient or overdesigned, causing repetitive refactoring and structural distortion.

**Organizational Causes**  
- Decisions made without technical understanding  
- Schedule setting and feature demands excluding technical perspectives  
- Lack of decision-making authority for CTOs or technical leaders  
- Strategic decisions made without technical advice

**Solution Philosophy**  
- Technical decisions must be made by those who **understand the technology**  
- Before holding developers accountable, those who made the decisions must bear **organizational responsibility**  
- Technical decisions must remain within the organization as **structures that are explainable and shareable**  
- The technical literacy of decision-makers should be clearly reflected as an evaluation criterion

**Practical Understanding**  
There is often a question that emerges in retrospectives after technical debt has accumulated:  
> "Why did we make that decision at that time?"

Such decisions are mostly **judgments made without technical context**.  
As a result, the organization falls into a vicious cycle of structural inefficiency, repetitive refactoring, and shirking responsibility.

This is not a problem of the developers.  
**It is a result created by the organization's structure, HR system, and leadership's perception.**

Decisions made without a proper understanding of technology are not just mistakes but  
transmute into risks for the entire organization.

**Key Sentence**  
> Technical debt is not a failure of developers but a failure of the decision-making structure.  
> When those who do not understand technology make technical decisions, it becomes a managerial risk.

---

# Preventing Technical Debt Through Culture

Technical debt cannot be resolved by merely modifying code.  
Unless **how the organization handles technology**, that is, the culture changes, technical debt will recur.

There is no need to introduce new frameworks or tools to reduce technical debt.  
More importantly, there are two things:

- Changing the perspective and order of the development process itself  
- Re-establishing the recognition and evaluation criteria for developers

To prevent technical debt,  
the organization should culturally establish the following **key practices**.

## 1. Interface-First Development Based on Mock Code

- Model **flows and interfaces before implementation**  
- This is not "adding work" but merely "changing the order of tasks"  
- Interface-focused development facilitates **TDD, documentation, review, and refactoring**

## 2. Culture of Code Style Centered on Readability

- Readable code is directly explainable code  
- If the flow is clear, the length of the code is not a significant problem  
- Complex code justified by performance optimization must always be explainable

## 3. Recognizing Documentation as a Performance Metric in the Organization

- Documentation is the foundation of organizational memory and collaboration  
- Those who write documents should be treated as **contributors**  
- The quality of documents should be a subject of review and **officially recognized as a performance metric**

## 4. Review is Not a Rule, But a Philosophy

- Review is not just about finding bugs, but a time to **share design philosophies**  
- Feedback should focus on structure, flow, and responsibility rather than grammar or style  
- Review criteria should be documented and shared within the organization

## 5. Technology Choices Must Consider Lifecycle and Organizational Capability

- Technology introduction should be judged not on being the "latest technology" but on **maintainability and replaceability**  
- Technology choices are strategic decisions of leadership and should consider **long-term structures, not short-term conveniences**

## 6. Knowledge is an Asset of the Organization, Not Individuals

- Knowledge does not preserve itself automatically; it requires **conscious organization and transfer**  
- Onboarding documents, system structures, and API usage guidelines must be recognized as **official outputs**  
- Contributions to knowledge should be quantitatively evaluated, and **this criterion starts with a transformation in management's perception**

Technical debt arises from a lack of culture.  
Thus, the most effective way to prevent technical debt is  
**for the organization to establish a culture that respects technology**.

---

# Operating a Day to Liquidate Technical Debt

Technical debt is unavoidable. And it accumulates.  
What matters is recognizing it and **systematically checking and reducing it repeatedly**.

The day to liquidate technical debt doesn't need to be grand or special.  
**Simply operating a regular 'Technical Debt Liquidation Day' and deciding what to do on that day is sufficient.**

This is not a declaration but an action, and this action can be concretized through the following practice items.

---

## I argue this:

### 1. Write documents explaining interfaces

- Specify **how data flows are designed between APIs or internal modules**  
- Even if no one else looks at it, **record it so that your future self can understand**

### 2. Interpret and explain spaghetti code

- Interpret **how the complexly entangled code structure was formed**  
- Organize who made those decisions and **what constraints and judgments were present at the time**

### 3. Explicitly state items recognized as technical debt

- Clearly declare and tag, **"This is technical debt."**  
- Plan **when to