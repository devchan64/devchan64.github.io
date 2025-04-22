---
date: 2025-03-20
layout: post
permalink: /en/2025/03/20/voiding_technical_debt_with_deletable_code.html
tags:
- Project
- Technical Debt
- Design Philosophy
title: 'Strategies to Avoid Technical Debt Through Removable Code'
---
> `gpt-4-turbo` has translated this article into English.

---

## Background

In environments with extensive End-to-End connectivity, features change frequently and interfacing with external systems can be complex.
Various temporary fixes and exception handling logic accumulate quickly. 
Especially when 'just make it work' code is not organized long-term:
- It soon solidifies into technical debt, deteriorating the system's maintainability and reliability.

## Problem

- Accumulation of temporary logic, exceptional handling, and test code becomes increasingly difficult to remove
- The purpose or conditions for removal of the code are unclear, making it impossible to answer "Can this code be deleted?" as time passes
- Missing the cleanup timing leads to the accumulation of technical debt, which results in increased incidents and operational costs

## Execution Strategy: Design and Operate with Deletability in Mind

> It's more important to design to prevent the accumulation of technical debt than to remove it.
> 
> The key is **to make code deletable**, namely to design a "structurally exitable" architecture.
> 

### Reason for Execution

- If the lifespan and deletion conditions of the code are not clear, technical debt becomes a hidden risk over time
- For code connected to various systems, the absence of cleanup criteria makes deletion impossible, which soon translates into incidents and maintenance burdens
- Therefore, considering the possibility of deletion from the time of code writing and systematically preparing cleanup routines is crucial

### Methods of Execution

1. **Specify Deletion Criteria**
    - Use comments like `REMOVE_BY`, `TODO (exp:)`, `@deprecatedUntil` to clearly mark the timeline and reason for removal in the code
    - Manage through review checks and regular inspections

2. **Clarify Code Responsibilities**
    - Record why it exists and how long it is needed, either inside the code or in a knowledge base
    - Track the history of code marked for deletion through release notes, team documents, etc.

3. **Focus on Habituation Over Automation**
    - While lacking infrastructure for automation and CI/CD integration, operate by substituting with a manual checklist-based repetitive review culture

4. **Design Exit Through Cleanup Time**
    - Explicitly allocate about 20% of the sprint schedule for code cleanup, refactoring, and documentation
        [https://devchan64.github.io/2025/04/14/technical-debt-is-not-about-code.html](https://devchan64.github.io/2025/04/14/technical-debt-is-not-about-code.html)
    - Focus on designing not just for simple structural improvements, but to "make the code deletable"

### Results

- Increase in code with clear deletion criteria, forming a routine of removing it before technical debt accumulates
- Team members voluntarily participate in managing deletion timing and history based on comments
- Balance maintained between cleanup cycles and feature development → maintaining code quality without schedule delays

## Insights

- Technical debt gets heavier the later it is addressed. **Code not designed for exit is a technical risk.**
- Cleanup should focus on 'deletability' rather than 'beauty'
- Ultimately, the strategy to avoid technical debt is realized when **organizational habits, a deletability-focused code culture, and clear exit conditions** are combined

## Key Messages

> "Cleanup is preparation to enable the exit of code."
> 
> "Do not write code that cannot be deleted."