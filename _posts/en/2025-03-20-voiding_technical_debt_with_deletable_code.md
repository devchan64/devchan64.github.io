---
date: 2025-03-20
layout: post
permalink: /en/2025/03/20/voiding_technical_debt_with_deletable_code.html
tags:
- Project
- Technical Debt
- Design Philosophy
title: '"Strategies to Avoid Technical Debt with Expiry-Ready Code"'
---

> `gpt-4-turbo` has translated this article into English.

---

## Background

In environments with extensive End-to-End connectivity, functional changes are frequent, and integration with external interfaces is complex. Various temporary solutions and exception handling logics accumulate rapidly. Especially, 'make-it-work' codes if not organized in the long term:

- Soon become ingrained as technical debt, reducing the system's maintainability and reliability.

## Problem

- Accumulation of temporary logic, exceptional handling, and test codes, gradually turning into a state that is difficult to remove
- The purpose of the code's existence or conditions for its removal are unclear, making it increasingly difficult to answer the question, 'Can this code be deleted?'
- Missing the timing for cleanup leads to the accumulation of technical debt, resulting in increased failures and operational costs

## Execution Strategy: Design and Operate with Expiry-Ready in Focus

> It's more important to design to prevent the accumulation of technical debt than to remove it.
> The key lies in **making the code deletable**, in other words, designing a "structure that facilitates exit."

### Reason for Execution

- If the lifespan and deletion conditions of the code are unclear, technical debt becomes a hidden risk over time
- The more a code is connected to various systems without clear cleanup criteria, the harder it becomes to delete, which soon translates into failures and maintenance burdens
- Therefore, considering Expiry-Ready from the code writing phase and systematically arranging cleanup routines are essential

### How to Execute

1. **Specify Deletion Criteria**

   - Clearly record the exit timing and reasons in the code using comments like `REMOVE_BY`, `TODO (exp:)`, `@deprecatedUntil`
   - Manage through review checks and regular inspections

2. **Clarify Code Responsibility**

   - Record why the code exists and how long it is needed, either inside the code or in a knowledge base
   - Manage traceability of code to be removed by linking with release notes, team documents, etc.

3. **Focus on Habituation Rather Than Automation**

   - Although not yet introduced to automation infrastructure for CI/CD, substitute with a culture of repetitive reviews based on a manual checklist

4. **Design Exit Through Cleanup Time**
   - Explicitly allocate about 20% of the sprint schedule for code cleanup, refactoring, and documentation
     [https://devchan64.github.io/2025/04/14/technical-debt-is-not-about-code.html](https://devchan64.github.io/2025/04/14/technical-debt-is-not-about-code.html)
   - Aim not just for structural improvements but for designing code that is "Expiry-Ready"

### Results

- Increase in codes with clear deletion criteria, forming a routine of removal before the accumulation of technical debt
- Team members voluntarily participate in managing deletion timings and history based on comments
- Maintains balance between cleanup cycles and feature development → Maintains code quality without schedule delays

## Insights

- Technical debt becomes heavier the later it is addressed. **Code that is not designed for exit is a technical risk.**
- Cleanup should be an activity for 'Expiry-Ready', not just for 'beautification'
- Ultimately, a strategy to avoid technical debt is realized when organizational habits, Expiry-Ready-focused code culture, and clear exit conditions are combined

## Key Message

> "Cleanup is a preparation to enable the code's exit."
> "Do not use code that cannot be deleted."