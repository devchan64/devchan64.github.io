---
date: 2025-12-03
layout: post
permalink: /en/2025/12/03/iot-saas-authorization-design-notes.html
tags:
- Retrospective
- Design Philosophy
title: IoT Control SaaS - Design Notes on Data Isolation, Permissions, and Tenant
  Inheritance
---

> `gpt-4-turbo` has translated this article into English.

---

### Data Isolation/Tenant Hierarchy/Role Inheritance/Authorization Model

This document is a **design note** intended to explain why we considered **data isolation (multi-tenant separation)**, **user permission model (RBAC/ABAC)**, and **tenant and role inheritance structure** in the IoT Control SaaS.

This is not a document to record the completed design, but a document that **organizes how the design direction was derived and the remaining unresolved tasks**.

---

## 1. Starting Point: Why Consider Such a Complex Structure?

The IoT Control SaaS operates equipment/users/data from multiple customers on a **single platform simultaneously**. This involves the following conflicting requirements:

1. **Data between customers must be completely separated.**
2. **There is a parent-child organizational structure within the same customer.**

Therefore, the concept of a single tenant alone could not meet the actual operational requirements.

This naturally led to the following concepts:

- **Parent-child structure between tenants**
- **Control of sub-tenants by the superior organization**
- **Inheritance structure of roles**
- Application of ABAC (Attribute-Based Access Control) if necessary

As a result, many ideas were borrowed from the **directory structure of the PC filesystem + Windows ACL inheritance model**.

---

## 2. Data is Designed Around the "Document"

IoT equipment/recipes/settings/diagnostics/logs all have **tree structure** characteristics. However, if a single document has an overly deep and complex tree, it:

- Makes schema changes difficult,
- Compromises backward compatibility,
- Reduces transmission and storage efficiency.

To solve this, we established the following principles:

### **Document Principle**

- All data is defined as **schema-based documents**.
- Documents are always referenced by a combination of `schemaName + refId`.
- Complex trees are split into multiple documents.
- The schema includes a **structure contract** with DTO, Validator, and Generator.

This approach prevents data mixing between tenants while enabling flexible expansion at the document level.

---

## 3. Tenant is Viewed as a "Tree" Structure

It is natural to manage tenants in a **tree structure**, similar to PC directories.

Example:

    /root
    /root/BrandA
    /root/BrandA/Shop01
    /root/BrandA/Shop02

This structure naturally provides the following functions:

- Superior tenants can fully control sub-tenants.
- Only specific roles can be granted "include child" permissions.
- Ancestor/descendant determination based on tenant path provides **performance close to O(1)**.

### Example of Tenant Structure

    tenantId
    parentTenantId
    path             // materialized path
    type             // organization type (e.g., HQ, branch, etc.)
    attributes       // attributes for ABAC

This structure is scalable and intuitive in operations, reporting, and UI.

---

## 4. Roles are Designed Similarly to "Object Inheritance"

In the field, roles have more significance than just simple tags.

Example:

- `TenantViewer`
- `TenantOperator` = Viewer + control functions
- `TenantOwner` = Operator + user management functions

For this, we applied a **parent-child inheritance structure** to Role.

    Role
    - roleId
    - parentRoleId
    - permissions[]

This allows common permissions to be elevated to the parent role, with additional permissions only extended to the child.

A realistic inheritance depth is 1-2 levels, considering operational complexity.

---

## 5. Introducing the "Scope" Concept to UserRole

Like Windows directory permissions, the scope of the role is specified.

    UserRole
    - userId
    - roleId
    - scopeTenantId   // reference tenant
    - scopeType       // EXACT | WITH_DESCENDANTS

Example:

- Administrator of a superior organization
  → `(scope=HQ, WITH_DESCENDANTS)`
- Specific store manager
  → `(scope=Shop01, EXACT)`

This meets the requirements of **hierarchical tenant + role inheritance + data isolation**.

---

## 6. Authorization Handling: Do Not Traverse Graphs at Request Time

If the tenant tree and role inheritance relationship are traversed per request, performance would significantly degrade.

The core principle is as follows:

### **All calculations are completed at the time of login or tenant switch.**

The procedure is as follows:

1.  Query all roles a user has in a specific tenant
2.  Unfold (flatten) the inheritance structure of these roles to form a complete set of permissions
3.  Integrate these permissions into a Set
4.  Store in cache or token

At request time, simply check the following:

    effectivePermissions.contains(permissionKey)

This method provides **consistent fast authorization performance** even in complex RBAC structures.

---

## 7. Why Choose This Design?

This structure is not to showcase a complex architecture. Rather, it is the form **naturally demanded by the domain-specific requirements of IoT Control SaaS**.

### Requirements ↔ Structure Correspondence Table

| Requirement                    | Solution via Structure             |
| ------------------------------ | ---------------------------------- |
| Complete data isolation between customers | Document isolation based on tenantId |
| HQ–branch structure            | Tenant hierarchy (Tree)            |
| Differential roles             | Role inheritance                   |
| Control of sub-organizations by superior organization | UserRole scope = WITH_DESCENDANTS |
| Fast authorization judgment    | effectivePermissions caching       |
| Document-based scalability     | Schema-based Document model        |

Ultimately, this design is derived from the intersection of **domain demands/data model constraints/operational realities**.

---

## 8. Remaining Challenges (Unresolved Issues)

### 8.1 Defining the Scope of Tenant Inheritance

- What settings to inherit?
- To what extent should documents/policies be allowed to inherit?

### 8.2 Limiting the Depth of Role Inheritance

- Allowance of override
- Need for a function to block parent permissions

### 8.3 Scope of ABAC Application

- Which attributes to allow
- Constraints needed to prevent complexity amplification

### 8.4 Strategy for Invalidating effectivePermissions

- When moving tenants
- When changing roles
- Rules for recalculating cache when Permission policies change

### 8.5 Cross-tenant Reference Policy

- Allow reference to parent documents?
- If allowed, under what conditions?

---

## 9. Conclusion: Meaning of the Design Note

This document is not a completed architecture document, but a memo and directional document that records **why such a structure was considered**, **how to simplify the essential problems of the domain**, and **what remaining challenges exist**.

In IoT Control SaaS, a multi-tenant structure, hierarchical organization, permission model, and document-based data model are inevitably required. The current design is an initial form that meets these requirements, and it also lays the groundwork for future scalability.