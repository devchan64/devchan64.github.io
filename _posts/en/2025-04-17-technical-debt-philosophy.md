---
date: 2025-04-16
permalink: /en/2025/04/17/technical-debt-philosophy.html
tags:
- Technical Debt
- Design Philosophy
title: '"Structural Thinking and Operational Philosophy Regarding Technical Debt"'
---
> `gpt-4-turbo` has translated this article into English.

---

During an interview, I was asked, "How do you manage technical debt?" At that time, I had not clearly organized my thoughts on the concept of technical debt, so I wrote this article to clarify my thinking.

## Language Alignment of Technical Debt

- Technical debt must be **clearly delineated**.
- **Debt is the result of decisions that require a repayment plan**,
- A **decision that was problematic but lacked a repayment plan** is not technical debt, but **technical failure**.

## Technical Debt is a Subject of 'Operation' Not Just 'Management'

- It's not just about listing and recording,
- **Structural resolution strategies must be designed and implemented**.
- I operate technical debt **on an execution basis**.

## Time-Based Classification of Technical Debt

### 1. Decisions that Skip Processes
- Examples: Skipping tests, omitting code reviews, not implementing automation, etc.
- Characteristics: Low interest, long-term repayment possible
- Philosophy: Prevention and repayment are possible through the introduction of tools and framework improvements

### 2. Decisions Made Without Postponing Decisions or Technical Validation
- Examples: Lack of architectural design, unverified scaling, introduction of temporary structures, etc.
- Characteristics: High interest, short-term repayment essential
- Philosophy: A prior repayment plan (1st, 2nd, 3rd phase) and an alternative plan are necessary

## Do Not Mislabel Technical Failures as Technical Debt

- Debt originates from 'choices with a plan to repay'.
- Problems identified later are not debts but **failures**.
- The moment these are misused as technical debt, **organizations choose justification over reflection**.

## Minimizing the Occurrence of Technical Debt is Crucial

- Structural prevention is key, rather than post-occurrence management.
- Design to prevent the occurrence of debt itself through tools, automation, linting, mockups, and template designs.

---

## Conclusion

> Technical debt is not simply a result of lacking technology.  
> It is the outcome of responsibility for decisions and structures.  
> I believe technical debt should be prevented with tools, decisions deferred should be absorbed through design, and failures should be handled structurally.  
> This is the operational philosophy of technical debt as I understand it.

---

I hope this helps those in need. This content is based on a real experience I had during an interview, and it reflects my standards developed through structurally solving technical debt and bottleneck issues across various domains.