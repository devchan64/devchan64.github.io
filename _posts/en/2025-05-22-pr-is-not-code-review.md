---
date: 2025-05-22
layout: post
permalink: /en/2025/05/22/pr-is-not-code-review.md.html
tags:
- Design Philosophy
- Organizational Culture
title: 'PR is Not Code Review: Structural Separation Begun Through Conversation'
---

> `gpt-4-turbo` has translated this article into English.

---

## 1. Misunderstandings Originating from Conversations

Recently, while discussing code reviews, I realized a mistake I made myself.  
I had been discussing PR (Pull Request) and code reviews interchangeably, which led to confusion about my intentions.

I once said:  
> “Rather than the approval process via PR, I value an approach based on retrospectives like ‘Refactoring Day’ where we review the entire code and check standards.”

Someone asked, “Don’t you think code reviews are important?”  
I interpreted this question as inquiring about the importance of PR reviews.  
So, I responded by saying, “It’s not that I don’t value code reviews, but that agreeing on common standards is more fundamental.”

Upon reflection, I realized that  
the 'code review' mentioned by that person might not have been just about the reviews on PRs,  
but about a cultural practice where the team creates standards together, shares context, and searches for better directions.

Ultimately, we were using the same words,  
but we were talking about different concepts.

---

## 2. Definitions of PR and Code Reviews

### Why PR and Code Reviews Are Confused

In many teams, code reviews occur alongside PRs.  
Most collaboration tools like GitHub, GitLab, etc., offer review functionalities on the PR screen,  
leading these two concepts to be perceived as part of the same flow.  
I too had perceived it this way, which sometimes led to misunderstandings.

Now, I distinguish between the two as follows:

### PR is a Formality

A PR is a technical interface requesting a code change.  
- Shares the outcome of work done on a branch  
- Requests a review before merging  
- Reviews the change history and test results

Thus, a PR is a formal request for review and approval, initiating collaboration.  
It is not code review itself but more like a container that holds the review.

### Code Review is a Process

Code review is a collaborative process where the team interprets and adjusts the intent, context, and structure of the code.  
- What the code aims to solve  
- Whether it's written according to team standards  
- If there's a structurally better direction  
- Whether future team members can maintain it

Code reviews can exist without PR.  
Design reviews, pair programming, and refactoring retrospectives are various forms of code reviews.

### Differences Between PR and Code Reviews

| Aspect     | PR                            | Code Review                       |
|------------|-------------------------------|-----------------------------------|
| Essence    | Technical request procedure   | Dialogue for collaboration and quality improvement |
| Functions  | Change request, approval, record, test | Intent verification, standard discussion, context sharing |
| Usage Time | After implementation          | Before, during, or after implementation |
| Existence  | Explicit on Git platforms     | Informal on various channels      |

### Reasons for Misunderstandings and Limitations

However, because these two structures are often used together,  
it is common to think that the review process is complete once someone clicks the approve button on a PR.  
This is a common misunderstanding.

A PR is merely a format that can hold a code review,  
but if the process of understanding intentions, checking standards, and discussing structures is omitted,  
the review is no different from not having occurred at all.

Moreover, another misunderstanding is that  
using the PR format will always include a review.  
However, the following situations often occur:

- Emergency PRs merged without review  
- Formal reviews that only seek approval without feedback  
- Structural simplifications where a single approval suffices  
- Significant code changes but reviews omitted due to time constraints

In these situations, I naturally experienced more instances where  
the PR structure failed to include reviews,  
leading me to question, "Is PR always a necessary structure?"

Ultimately, my conclusion is this:

While PR is an integrated structure that can contain code reviews,  
not all situations can accommodate reviews.  
To ensure that the intent and goals of reviews are effectively realized,  
it is necessary to recognize and design PRs and code reviews as separate structures.

---

## 3. Problems Created by Confusing PR and Code Reviews

While a PR can contain a code review, reviews often do not function properly within it.  
Nevertheless, operating as if the two concepts are the same leads to the following repetitive problems for the team.

Mistaking non-review activities for reviews,  
structurally omitting necessary reviews,  
and ultimately reducing code reviews to mere procedures.

### 3-1. Reviews Are Reduced to Approval Processes

Reviews are not discussions about the quality of code but are reduced to a "pass-check procedure" before merging.

- “Did it pass the test?” → ✅ → Merge  
- Reviewers only check conventions and test statuses before approving  
- Discussions about structure, design, and purpose are omitted

Ultimately, reviews become a checklist for approval, not a quality assurance.

---

### 3-2. Feedback Is Repeatedly Neutralized

When reviews start late, or there is a large, urgent PR,  
it often ends with, “It’s difficult to modify now.”

- In urgent feature releases or hotfixes, the culture of “merge now, review later” repeats  
- Feedback becomes a burden for the author, leading to defensive reactions

If this situation repeats, reviews become something to be avoided.

---

### 3-3. Knowledge Does Not Accumulate in the Team

When reviews occur only between specific individuals as approval processes,  
the context of the code remains with only a few team members.

- The intent and design rationale of the code are not shared with the entire team  
- Eventually, a codebase that has code but lacks context is created

Teams like this face increasingly high onboarding costs,  
and the question, “Why was this made this way?” repeats.

---

### 3-4. Reviews Become an Exceptional Practice

- “I asked for a review, but it wasn’t done”  
- “Someone else approved it, and I just merged it”  
- “It was urgent, so I skipped it”

If reviews are repeatedly bypassed,  
it is a sign that **reviews are not functioning as a culture**.

---

## 4. What Constitutes a Well-Functioning Code Review Structure

Code review is not merely a procedure to block merging.  
It is a tool for collaboration where the team interprets the quality of code together,  
and aligns common standards and context.

A well-functioning code review has the following structural features.

---

### 4-1. Interpreting the ‘Intent’ of the Code Together

- “What problem was this design intended to solve?”  
- “Why did you choose this separation method?”  
- “Was this structure considered for future expansion?”

Reviews are not just code audits but  
a dialogue interpreting the author’s choices and context together.

---

### 4-2. Feedback Goes Back and Forth According to the Team’s ‘Standards’

- Conventions, responsibility division, inclusion of tests, etc.  
- Judgments are not based on individual discretion but on standards agreed upon by the team beforehand

The clearer the standards,  
the more reviews become alignment rather than interference.

---

### 4-3. Feedback Is Expressed in the Language of ‘Exploration and Suggestion’

- “This method is fine, but how about this structure?”  
- “This part could be considered for refactoring later”

When feedback is given in the language of dialogue and exploration rather than criticism or evaluation,  
the author does not become defensive, and reviews become an opportunity for growth.

---

### 4-4. Reviews Continue Before and After PR

- Pre-implementation design reviews, discussions on interfaces between features  
- Post-deployment refactoring retrospectives or technical debt reviews

Reviews are not procedures that exist only within PRs.  
**Throughout the entire flow of creating and operating code**,  
reviews should be a structure that revisits context and aligns quality.

---

## 5. What Constitutes a Well-Functioning PR Structure

A PR is a technical structure that can contain a code review.  
However, it does not ensure that reviews are conducted properly by itself.  
For a PR to function properly, the following conditions must be met.

---

### 5-1. The Purpose and Context Are Clearly Described

- “What problem does this change solve?”  
- “What has changed from before, and why did you choose this method?”

A PR should not only contain code changes but also  
the **background and intent** behind those changes.  
This allows reviewers to understand the context together.

---

### 5-2. Composed of a Single Purpose and Appropriate Volume

- A single PR should contain **only one topic or purpose**  
- Maintains a reviewable scope (functional unit, appropriate amount of code)

Large and complex PRs make reviews difficult,  
and ultimately, only approval remains, blurring the review.

---

### 5-3. A Flow for Reviewers Is Organized

- Commit units are logically divided  
- Configuration files, test codes, and key changes are **distinctly readable**

A PR is a ‘document for review’.  
**It needs a considerate structure that allows reviewers to naturally follow along**.

---

### 5-4. The Flow After Merging Is Clearly Defined

- Automatic deployment after merging? Manual release? Where is QA conducted?  
- If there are reasons not to merge even after the review is complete, they should be specified

A PR is not just about code changes,  
but includes the team’s collaboration flow as well.

---

## 6. Do Refactoring Day and Code Reviews Conflict?

Sometimes I get asked, “If code reviews work well, isn’t Refactoring Day unnecessary?”  
However, in reality, **these two concepts do not conflict**.

Code reviews are short breath checks that occur within the flow of feature development,  
while Refactoring Day is a long breath retrospective that re-aligns standards by reviewing the entire flow.

---

### Comparison: Code Review and Refactoring Day

| Category        | Code Review                      | Refactoring Day                    |
|-----------------|----------------------------------|------------------------------------|
| Focus           | Code currently being written     | Entire flow and standards of accumulated code |
| Operational Time| During feature development, PR phase | After feature completion, periodic retrospective moments |
| Main Functions  | Checking code standards, structural improvement, feedback | Checking the standards themselves, organizing patterns, resetting designs |
| Benefits to the Team | Maintaining quality, sharing design intent | Organizing technical debt, realigning the codebase |

---

### Summary

Refactoring Day examines the flows that code reviews miss.  
And code reviews become the pathway to reapply standards after Refactoring Day ends.

Both look at different aspects:  
- One looks at **now**,  
- The other looks at **so far**.

Their rhythms are different, but  
together, they maintain the team’s quality and allow standards to evolve.

---

## 7. Creating a Repeatable Review Culture

Good code reviews are possible even as one-offs.  
However, to make them **repeat and sustain as a team culture**,  
relying solely on individual diligence or responsibility is insufficient.

A repeatable review culture is built on the following structural foundations.

---

### 7-1. The Purpose and Perspective of Reviews Are Agreed Upon at the Team Level

- What are reviews meant to examine?  
- What standards and priorities are used for giving and receiving feedback?

Everyone in the team should be able to speak the same language in response to these questions,  
so reviews do not operate differently depending on the individual.

---

### 7-2. Reviews Are Included in Work Hours

- “Please look at it when you have time” does not repeat.  
- Reviews must be **explicitly planned and measured as part of the work**.

If time is not secured, reviews will always be postponed behind "urgent matters".

---

### 7-3. Review Results Are Recorded and Reflected

- Good feedback is organized into standards,  
- and missed points are reflected in the next review.

Reviews should not only leave behind code,  
but also **team judgments and standards**  
to accumulate as culture.

---

### 7-4. The Structure, Not the Individual, Sustains the Review Culture

- Depending on a specific senior or one passionate person,  
  the review culture disappears the moment that person leaves.

Review standards and responsibilities must be **repeatedly placed within roles and structures**.

---

### 7-5. There Are Reviews About the Review (Retrospectives)

- “Why was this review missed?”  
- “Did this review function well?”  
- “Did we miss a common pattern?”

Code review is ultimately a process.  
**Regular meta-reviews of this process** must be performed  
for an organization to evolve its review culture.

---

## 8. Review Structures Can Vary

While I have structurally explained the review culture so far,  
it does not mean that PR-based code reviews are the only answer.

Depending on the organization's structure, collaboration tools, and the nature and speed of the product,  
the way reviews function can significantly differ.

---

### Review Methods Vary Depending on Team Structure

- Small startups may find it more effective to give and receive feedback verbally quickly,  
- and teams with extensive remote work may find asynchronous PR-based reviews more stable.

---

### Review Points Differ Depending on Deployment Methods

- Some teams have a GitOps structure where PR merging equals deployment,  
- while others have separate QA or testing stages and manage releases with internal tools.

Reviews do not necessarily need to be tied to PRs.

---

### Review Experiences Differ Among Individuals

- Someone who has collaborated without PRs,  
- someone who has worked in a team where all changes were merged without reviews,  
- and conversely, someone from a team where merging without approval was impossible.

Thus, the same word 'review'  
**carries different contexts and memories for each person**.

---

### Ultimately, the Form Isn’t What’s Important

Is the review functioning?  
Is it operating as a structure that divides the quality and responsibility of the code?

If so, whether it's PR-based, face-to-face, or retrospective-centered,  
**that method is valid**.

---

## 9. Conclusion

A PR is a technical format that contains code reviews,  
and a code review is a collaborative process that encapsulates the culture and standards of the team.

These two are not the same but can interlock together.  
When PR creates the flow, and code review fills it with meaning,  
collaboration transcends mere procedures.

---

A team where reviews function well does not just review code,  
but **reviews trust and standards between people**.

With that structure,  
reviews become culture,  
and culture can be repeated.

---

What’s important is not the form but the structure,  
not the procedure but the intent,  
and above all,  
**whether it is repeatable**.

---

## Appendix. Examples of Code Review Criteria

- Does this code convey **intent**?
- Does it **naturally fit** the team’s standards and flow?
- Is the structure **easy to maintain** for team members after the review?
- Have the tests and scope of impact been **adequately considered**?

> 📌 Code review is not about finding what’s ‘wrong,’  
> but about asking if we can **improve together**.

---

## Appendix. Examples of PR Criteria

- Is there a **description explaining why this change was made**?
- Is it a PR with **only one purpose**?
- Is it **considerate** enough for the reviewer to understand?
- Are the merge scope and timing **appropriate**?

> 📌 PR is not for the code,  
> **but for the people**.