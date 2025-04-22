---
date: 2025-04-17
permalink: /en/2025/04/17/technical-debt-philosophy.html
tags:
- Technical Debt
- Design Philosophy
title: Structural Thinking and Operational Philosophy on Technical Debt
---
> `gpt-4-turbo` has translated this article into English.

---

I was once asked in an interview, "How do you manage technical debt?" At that time, I had not clearly defined the concept of technical debt, so I am writing this article to organize my thoughts.

## Language Alignment of Technical Debt

- Technical debt must be **clearly segregated**.
- **Debt is the result of a decision that requires a repayment plan**,
- A **decision that was problematic but lacked a repayment plan** is not technical debt but **technical failure**.

## Technical Debt is Not Just Managed, but Operated

- It’s not just about listing and recording,
- You must **design and implement a structural resolution strategy**.
- I operate technical debt **on an execution basis**.

## Time-Based Classification of Technical Debt

### 1. Decisions Made by Skipping Processes
- Examples: Skipping tests, omitting code reviews, not adopting automation, etc.
- Characteristics: Low interest, long-term repayment possible
- Philosophy: Prevention and repayment are possible through the introduction of tools and improvement of frameworks

### 2. Decisions Made Without Postponing Decision-Making or Technical Validation
- Examples: Lack of structure design, unverified scaling, introduction of temporary structures, etc.
- Characteristics: High interest, immediate repayment necessary
- Philosophy: A prepayment plan (1st, 2nd, 3rd) and an alternative plan are essential

## Technical Failures Should Not Be Disguised as Technical Debt

- Debt arises from a 'choice with a plan to repay'.
- Problems identified later are not debts but **failures**.
- The moment you misuse this as technical debt, **the organization chooses justification over reflection**.

## Minimizing the Occurrence of Technical Debt is Crucial

- Structural prevention is key rather than post-occurrence management.
- Design tools, automation, linting, mocks, and templates to **prevent the debt from occurring at all**.

---

## Conclusion

> Technical debt is not just a result of lacking technology.  
> It is a result of responsibility for judgment and structure.  
> I believe that technical debt should be prevented with tools, deferred judgments should be absorbed through design, and failures should be structurally addressed as failures.  
> This is my operational philosophy of understanding technical debt.

---

I hope this is helpful to those who need it. This content is based on a real experience I had during an interview, and it reflects my standards that have structurally resolved technical debt and bottlenecks in various domains.