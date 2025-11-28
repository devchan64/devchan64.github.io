---
date: 2025-11-28
layout: post
permalink: /en/2025/11/28/architect-core-principles-loose-coupling-ssot-workflow.html
tags:
- Retrospective
title: Three Key Pillars I Value as an Architect
---

> `gpt-4-turbo` has translated this article into English.

---

# Three Key Aspects I Value as an Architect

When considering software architecture, there are standards that I consistently return to.  
These are the three axes that help create a robust structure, stabilize the team, and maintain a scalable foundation amidst changes.  
Here are the essentials summarized in a memo.

---

## 1. Design Standards — The Power of Structural Stability

### Fragmentation → Loose Coupling
Breaking down functions into smaller units and defining clear boundaries reduces coupling between modules.  
Such a structure enhances replaceability and lowers the risk of failure propagation, making parallel development across teams much easier.

- Single responsibility per module
- Explicit interfaces
- Blocking implicit data sharing

### Layering → Flexible Scalability
Separating layers ensures that core Domains remain stable despite external changes (DB, frameworks, UI).  
This separation facilitates maintenance, testing, and replacement, and extends the system's lifespan.

- Separation of roles in Domain / Application / Infra
- Separation of flow and rules
- Adapter-based replaceable structure

---

## 2. Single Source of Management — The Benchmark that Unifies the Entire System

### Single Source of Truth
When models, schemas, and settings are redundantly defined in multiple locations, changes become unpredictable.  
Consolidating these into a single standard can reduce problems by 70%.

- Centralization of common models and types
- Unification of Config / Feature Flag / Locale
- Version management of API and Schema

### Blocking Accidental Dependencies
Preventing modules from referencing information they don’t need to know is the essence of architectural quality.

- Removal of unclear imports
- Prohibition of direct references between layers
- Provision of stable Public APIs

---

## 3. Workflow Organization — The Structure That Influences Team Productivity

### Flow-Based Structuring
As systems grow, **Flow becomes the benchmark**.  
Standardizing common flows like Save Flow, Brew Engine Flow, and Cleaning Flow can exponentially increase team speed.

- Standardization of states and events
- Consistent logic for errors/cancellations/retries
- Sharing identical flows across Front/Back/Device

### Eliminating Repetition Through Automation
A structure that avoids wasting time on environmental differences, focusing instead on solving essential problems.

- Standardization of CI/CD pipelines
- Provision of Simulator / Mock / Playground
- Bridging environmental gaps with common CLI and scripts

---

## Conclusion — The Architect’s Three Key Questions

| Axis | Key Question |
|---|-----------|
| **Design Standards** | Does the structure withstand changes? |
| **Single Source of Management** | Are standards consolidated into one? |
| **Workflow Organization** | Does the team operate in the same manner? |

Architecture is less about complex technologies and more about "setting standards and maintaining them."  
If these three axes remain stable, the entire system can grow stably.