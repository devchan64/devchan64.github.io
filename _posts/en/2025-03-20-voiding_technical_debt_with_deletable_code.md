---
date: 2025-03-20
layout: post
permalink: /en/2025/03/20/voiding_technical_debt_with_deletable_code.html
tags:
- Project
- Technical Debt
- Design Philosophy
title: '"Strategies to Avoid Technical Debt Through Removable Code"'
---
> `gpt-4-turbo` has translated this article into English.
---

## Background

In environments with many End-to-End connections, frequent functional changes and complex interactions with external interfaces lead to the rapid accumulation of various exception handling and temporary response logic. Particularly, if the "make it work first" code is not organized in the long term, it soon becomes entrenched as technical debt, lowering the system's maintainability and reliability.

## Problem

- Temporary logic, exception handling, and test code accumulate, becoming increasingly difficult to remove.
- The reason for the code's existence or the conditions for its removal are unclear, making it impossible to answer the question "Can this code be deleted?" as time passes.
- Missing the timing for cleanup leads to the accumulation of technical debt, which results in increased failures and operational costs.

## Execution Strategy: Design and Operate with Deletability in Mind

> It is more important to design to prevent the accumulation of technical debt rather than removing it.
>
> 
> The key is **making code deletable**, in other words, designing a "structurally exitable" framework.
>

### Reason for Execution

- If the lifespan and deletion conditions of the code are unclear, technical debt becomes a hidden risk over time.
- The more a code is connected with various systems, the impossibility of deletion without clear cleanup criteria soon translates to failures and maintenance burdens.
- Therefore, considering the possibility of deletion from the point of writing the code and systematically arranging cleanup routines is essential.

### Execution Process

1. **Design Exits through Cleanup Time**
   - Explicitly allocate about 20% of the sprint schedule to code cleanup, refactoring, and documentation.
   - Aim not just for simple structural improvements but for making code deletable.
2. **Specify Deletion Criteria**
   - Record the exit timing and reasons in the code with comments like `REMOVE_BY`, `TODO (exp:)`, `@deprecatedUntil`.
   - Manage through review checks and regular inspections.
3. **Clarify Code Responsibility**
   - Record why the code exists and until when it is needed either inside the code or in a knowledge base.
   - Link with release notes, team documents, etc., to enable tracking the history of code marked for deletion.
4. **Operate Focused on Habituation Rather than Automation**
   - Although not implemented CI/CD integration due to a lack of automation infrastructure, substitute operation with a manual checklist-based repetitive review culture.

### Results

- The increase in codes with clear deletion criteria forms a routine of removing technical debt before it accumulates.
- Team members also voluntarily participate in managing deletion timing and history based on comments.
- Balance between cleanup cycles and feature development is maintained → maintaining code quality without schedule delays.

## Insight

- The later you clean up technical debt, the heavier it gets. **Code not designed for exit is a technical risk.**
- Cleanup should be an activity for 'deletability', not 'beauty'.
- In the end, a strategy to avoid technical debt is realized when organizational habits, a deletability-centered code culture, and clear exit conditions are combined.

## Key Message

> "Cleanup is preparation for making the exit of code possible."
>
> 
> "Do not write code that cannot be deleted."