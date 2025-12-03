---
categories:
- 회고
- 설계철학
date: 2025-12-03
layout: post
permalink: /en/2025/12/03/iot-saas-authorization-design-notes.html
title: 'IoT Control SaaS: Notes on Data Isolation, Permissions, and Tenant Inheritance
  Design'
---

> `gpt-4-turbo` has translated this article into English.

---

# Part 1: IoT Control SaaS Design Notes

### Data Isolation · Tenant Hierarchy · Role Inheritance · Authorization Model

This document is a **design note** intended to explain why we considered **data isolation (multi-tenant separation)**,\
**user permission models (RBAC/ABAC)**, and **tenant and role inheritance structures** in IoT Control SaaS.

This is not a document to record a finalized design, but a document that **summarizes unresolved issues and how the design direction was derived**.

---

## 1. Starting Point: Why Consider Such a Complex Structure?

IoT Control SaaS operates multiple customers' equipment, users, and data **simultaneously on a single platform**.\
This involves conflicting requirements:

1. **Data between customers must be completely isolated.**
2. **There is an upper-lower organizational structure within the same customer.**

Therefore, a single tenant concept alone could not meet the actual operational needs.

This naturally led to the following concepts:

- **Parent-child structure between tenants**
- **Control of sub-tenants by the upper organization**
- **Inheritance structure of roles**
- Application of ABAC (Attribute-Based Access Control) when necessary

Consequently, we borrowed many ideas from the **PC filesystem directory structure + Windows ACL inheritance model**.

---

## 2. Data is Designed Around the "Document" Concept

IoT equipment, recipes, settings, diagnostics, and logs all have **tree-like characteristics**.\
However, if a single document has a very deep and complex tree, it leads to:

- Difficulty in schema changes
- Challenges in maintaining backward compatibility
- Reduced efficiency in transmission and storage

To solve these issues, we established the following principles:

### **Document Principles**

- All data is defined as **schema-based documents**.
- Documents are always referenced by a combination of `schemaName + refId`.
- Complex trees are separated into multiple documents.
- The schema includes a **structural contract** incorporating DTOs, Validators, and Generators.

This approach prevents the mixing of data between tenants while allowing for flexible expansion at the document level.

---

## 3. The Tenant (Tenant) is Viewed as a "Tree" Structure

Managing tenants like a PC directory in a **tree structure** is natural.

Example:

    /root
    /root/BrandA
    /root/BrandA/Shop01
    /root/BrandA/Shop02

This structure naturally provides the following features:

- Upper tenants can control all sub-tenants
- Only specific roles are given "include children" permissions
- Ancestor/descendant determination based on tenant path provides **performance close to O(1)**

### Example of Tenant Structure

    tenantId
    parentTenantId
    path             // materialized path
    type             // type of organization (e.g., HQ, branch, etc.)
    attributes       // Attributes for ABAC

This structure is scalable and intuitive in operations, reporting, and UI.

---

## 4. Roles (Role) are Designed Similar to "Object Inheritance"

In practice, roles mean more than just simple tags.

Examples:

- `TenantViewer`
- `TenantOperator` = Viewer + control functions
- `TenantOwner` = Operator + user management functions

For this, we applied a **parent-child inheritance structure** to Roles.

    Role
    - roleId
    - parentRoleId
    - permissions[]

This allows common permissions to be elevated to the parent role, and additional permissions to be extended only to the child.

A realistic depth of inheritance considers operational complexity to be 1~2 levels.

---

## 5. Introducing the "Scope" Concept to UserRole

Like Windows directory permissions, the scope of the role's validity is specified.

    UserRole
    - userId
    - roleId
    - scopeTenantId   // reference tenant
    - scopeType       // EXACT | WITH_DESCENDANTS

Example:

- Upper organization administrator\
  → `(scope=HQ, WITH_DESCENDANTS)`
- Specific store manager\
  → `(scope=Shop01, EXACT)`

This allows us to meet all the requirements of **hierarchical tenants + role inheritance + data isolation**.

---

## 6. Authorization Processing: Do Not Traverse Graphs at Request Time

If the tenant tree and role inheritance relationships are traversed with each request, performance would be greatly degraded.

The key principle is as follows:

### **Complete all calculations at login or tenant switch time.**

The procedure is as follows:

1.  Query all roles a user has in a specific tenant\
2.  Unfold (flatten) the inheritance structure of these roles to form a complete set of permissions\
3.  Integrate these permissions into a Set\
4.  Store in cache or token

At the time of request, simply check the following:

    effectivePermissions.contains(permissionKey)

This method provides **consistent fast authorization performance** even in complex RBAC structures.

---

## 7. Why Choose This Design?

This structure is not to showcase a complex architecture.\
Rather, it is the form **naturally required by the domain-specific demands of IoT control SaaS**.

### Requirements ↔ Structure Correspondence Table

| Requirement                        | Solution Structure                   |
| ---------------------------------- | ------------------------------------ |
| Complete data isolation between customers | Document isolation based on tenantId |
| Headquarters–branch structure      | Tenant hierarchy (Tree)              |
| Differentiated roles               | Role inheritance                     |
| Control of sub-organizations by the upper organization | UserRole scope = WITH_DESCENDANTS    |
| Fast authorization determination   | Caching effectivePermissions         |
| Scalability based on documents     | Schema-based Document model          |

Ultimately, this design is derived from the intersection of **domain requirements, data model constraints, and operational realities**.

---

## 8. Remaining Challenges (Unresolved Points)

### 8.1 Definition of Tenant Inheritance Scope

- What settings to inherit?
- To what extent should documents and policies be inherited?

### 8.2 Limitation of Role Inheritance Depth

- Whether to allow overrides
- Need for a feature to block parent permissions

### 8.3 Scope of ABAC Application

- Which attributes to allow
- Restrictions needed to prevent complexity increase

### 8.4 effectivePermissions Invalidate Strategy

- When changing tenants
- When changing roles
- Rules for recalculating the cache when permission policies change

### 8.5 Cross-tenant Reference Policy

- Whether to allow references to parent documents
- If allowed, what conditions?

---

## 9. Conclusion: The Significance of the Design Notes

This document is not a complete architecture document, but a memo and directional document that records **why such a structure was considered**, **how to simplify the fundamental problems of the domain**, and **what challenges remain**.

In IoT Control SaaS, multi-tenant structures, hierarchical organizations, permission models, and document-based data models are inevitably required.\
The current design satisfies these requirements in its initial form and has laid the foundation for future expansion possibilities.

---

# Part 2. Designing Data Isolation and Permission Models for IoT SaaS

This document is not just a theoretical design, but a record of the **data isolation (multi-tenancy)** and **permission/authorization models** that have been tested in building and operating actual IoT Control SaaS.

The features of the current version include:

- **Document-centered data model**

  - All data is managed in independent document units with `tenantId`, `schemaName`, and `refId`.
  - Enforces document structure and meaning through schema-based DTOs/Validators.
  - When tree structures are needed, it prevents a single document from becoming too bulky by dividing it into multiple documents.

- **Tenant Hierarchy and Directory Analogy**

  - Tenants have `tenantId`, `parentTenantId`, and `lineage(/root/brandA/shop001)`, and are managed like a PC filesystem directory in a hierarchical structure.
  - This structure allows **upper tenants → sub-tenants** to be designed with control and query permissions.
  - However, the data itself always belongs only to its `tenantId`, and
    the ability to access between upper and lower levels is controlled only by **permission/role scope**.

- **Role + Permission + Scope Combination**

  - A Role is a meaningful bundle of actions (e.g., TenantViewer, TenantOperator, DeviceMaintainer), and
    Permission is defined as a combination of `action + resourceType + condition(scope)`.
  - The structure `UserRole(userId, roleId, scopeTenantId, scopeType)` expresses
    “which user can perform which role in which tenant scope”.
  - Using `scopeType = EXACT | WITH_DESCENDANTS` supports the pattern of **an upper tenant (parent tenant) controlling sub-tenants (child tenants) at once**.

- **Near O(1) Authorization Decision Flow**

  - At the time of login or tenant switch,
    `effectivePermissions(userId, tenantId)` is calculated and cached.
  - At the time of the actual request, it is simply checked whether
    the Permission exists for the `userId + tenantId + permissionKey`.
  - As a result, even as the number of tenants and users increases,
    the authorization judgment for individual requests remains nearly O(1).

- **Unified IoT Device–Tenant Mapping**

  - Each device is affiliated with a single `tenantId`,
    and all data, commands, and logs collected are stored and queried within the scope of that tenant immediately upon receipt.
  - When switching tenants on the control screen, only devices and documents belonging to that tenant are queried, and
    upper organization users can view sub-tenants at once with a `WITH_DESCENDANTS` scope.

This structure has been operated and verified in an environment with **a small number of multi-tenants + a limited number of devices**.

- At the single tenant level,
  - The document-based schema structure and authorization model operated sufficiently simply and intuitively.
- In an environment where parent-child tenants are mixed,
  - It was possible to implement scenarios for controlling upper/lower organizations using the `WITH_DESCENDANTS` scope.
  - However, role inheritance, cross-tenant references, and policy inheritance (model inheritance) are
    still "partially" in use, and more sophisticated modeling is needed in the future.

The remaining sections (1–9) of this document are based on the operational version introduced above

- To satisfy which requirements
- What domain model (document, schema, tenant, role, permission) was defined and
- How the authorization service and IoT control scenario were designed

are elaborated in a more refined design language and structure.

---

# 1. Overview

This document summarizes how to design and implement **data isolation (multi-tenancy)** and **permission/authorization** structures in an IoT-based SaaS platform. The approach introduced here is based on real operational experience, and it defines how to integrate different domains such as tenant structure, document-based data model, role/permission model, and IoT device mapping into a consistent structure.

In particular, it focuses on the following three goals:

1. **Complete data separation by customer/organization unit**
   - Each tenant has an independent data area, and the structure ensures that data from different tenants is neither mixed nor exposed at any level.

2. **Maintaining a flexible document-based data model**
   - Manages various data types such as IoT device status, settings, profiles, recipes, and user logs uniformly at the document level, while ensuring structural stability and validity through the schema.

3. **Building a scalable permission/authorization model**
   - Configures the authorization judgment to operate without burden even as the number of tenants and users increases, and expresses complex SaaS operation scenarios using various roles and permissions.

In this way, the overall structure goes beyond a simple RBAC (Role-Based Access Control),
including tenant hierarchical structure, document-centric model, and IoT device mapping,
aiming for a **kind of domain architecture (Architecture for Domain Isolation & Authorization)**.

The following sections of this document sequentially explain the **requirements → domain model → isolation strategy → authorization model → operational scenario → scalability structure** prepared to achieve these goals.

---

# 1.5 Concept of Tenant

The term **Tenant** used in this document is borrowed from a commonly used term in other SaaS services,
meaning a **logical data partition unit** defined to clearly separate data by organizational unit.

Basically, tenants serve the following purposes:

- Provide completely separated areas so that data from different organizations does not mix.
- All data entities such as users, devices, and documents (Document) must belong to one tenant.
- It can be organized hierarchically like upper and lower organizations,
  and can be expressed in a tree structure like a filesystem directory.

## Why We View Tenants as Filesystem Directories

In this design, the tenant structure is defined as a concept similar to the **filesystem directory structure**.
The background is as follows:

1. **Clarity of Data Isolation**

   - Just as files in different paths do not mix in a directory,
     each tenant does not mix data with other tenants.

2. **Scalability and Intuitiveness**

   - If the organization has an upper-lower structure,
     expressing it as a **path-based tree** like `/root/organizationA/branch001` satisfies
     both structural consistency and intuitiveness.

3. **Simple Expression of Policy and Permission Inheritance Model**

   - Like a directory based on a tree,
     the policy that "an upper organization can control a lower organization" can be
     simply expressed with scopes like `WITH_DESCENDANTS`.

## Information Included in Tenants

Tenants are entities with the following attributes:

- `tenantId`: A unique ID that identifies the tenant
- `parentTenantId`: ID of the upper tenant
- `lineage`: The path from the root to the current tenant (e.g., `/root/orga/sub1`)
- Basic metadata such as `name`, `type`, `status`, etc.

## Why Tenants are Important in This Document

Most of the design in this document starts from the following principles:

- All data models such as **Document, User, Device, Log** must belong to one tenant.
- **Data access permissions (Authorization)** are always judged based on the context of
  "which tenant's data is being accessed?"
- Whether an upper organization can manage the data of a lower organization is controlled only by **Role** and **Scope**.

Therefore, the tenant serves as the **basic unit of data isolation and the core axis of the permission model** throughout the design of this document.

---

# 2. Requirements Definition

In designing the data isolation and permission/authorization model for IoT Control SaaS, the requirements to be met are first defined in terms of functional and non-functional aspects. These requirements will serve as the design basis for the subsequent domain model and authorization structure.

## 2.1 Functional Requirements

### 1) Independent Management by Tenant (Tenant)

- Each organization must be managed as an independent tenant.
- Data from different tenants must be completely separated by default.

### 2) User–Tenant–Role Structure

- Users can have relationships with one or more tenants.
- Users are assigned roles by tenant.
- Roles define access permissions for specific resources such as documents (Document), devices (Device), and configurations (Configuration).

### 3) Document (Document) Access Control

- Users should be able to read, write, and manage specific document schemas according to their roles.
- Permissions can be detailed by schema level, document type, or specific Resource.

### 4) Device-Level Access Control

- Users should have limited access rights to specific devices or device groups.
- Device data (logs, status, commands) must be accessible only within the scope of the tenant to which the device belongs.

### 5) Support for Upper-Lower Organizational Structure

- Upper organizations should be able to control the status of lower organizations if necessary.
- However, accessibility is not automatically granted by the upper-lower relationship of tenants but must be controlled by **Role (Role) and Scope (scope)**.
- Basic Principles:
  - Lower organizations cannot view upper organization data by default.
  - Upper organizations can control lower organizations only when a permitted scope is assigned.

---

## 2.2 Non-Functional Requirements

### 1) Performance of Authorization Judgment

- Authorization judgment should be processed in **time close to O(1)** per request.
- There should be no performance degradation even with many tenants, users, and various roles.

### 2) Scalability (Scalability)

- Even if the number of tenants, users, and devices increases, the load on the authorization service should only increase linearly.
- In a distributed environment, cache and tenant structure queries for authorization must operate efficiently.

### 3) Stability of Model Changes

- Schema, permission structure, tenant hierarchy changes should be safely expandable.
- Document schema changes should have a version management system and support automatic/manual migration procedures for existing data.

### 4) Accurate Tenant Routing of IoT Data

- Data (logs, status, commands) coming from IoT devices must clearly distinguish the tenant ID at the protocol level.
- Defensive design must be in place to ensure that data is never mixed with the wrong tenant.

---

# 3. Domain Model

The data isolation structure of IoT SaaS is composed of interactions between several entities such as Document (Document), Schema (Schema), Tenant (Tenant), User (User), Role (Role), Permission (Permission). This section defines the core domain models that make up the entire structure and explains how each model contributes to data isolation and authorization judgment.

---

## 3.1 Document (Document) Model

In this design, most data is stored as units called **documents (Document)**. Documents play the role of accommodating various data such as IoT device status, recipes, profiles, user logs, and settings in a unified structure.

### Common Attributes of Documents

All documents commonly have the following attributes:

- `tenantId`  
  The tenant to which the document belongs. It is the primary criterion for data isolation.

- `schemaName`  
  The name of the schema that determines the structure and meaning of the document.

- `refId`  
  A unique reference ID that can globally identify the document.

- `payload`  
  The actual data of the document. It is verified by the schema (DTO/Validator).

- `meta`  
  Additional information about the document, such as creator, creation time, modification history, version, etc.

### Design Principles

1. **A schema must exist to create a document.**  
   Documents with arbitrary structures are not allowed.

2. **References between documents are made only with `(schemaName, refId)`.**  
   Path-based, tree-based references, etc., are not allowed, and
   dependencies between documents are managed with explicit schema-level references.

3. **Tree structures are configured by dividing the document when necessary.**  
   Deep trees are not placed in a single document but are composed of loosely structured multiple documents.

This model allows data to **maintain sufficient flexibility while being strongly structured**.

---

## 3.2 Schema (Schema) and DTO

The schema defines the **structure (Structure)**, **data type**, and **semantic constraints** of a document as a contract (Contract).  
All documents are created, modified, and verified according to the rules defined by their schema.

### Components of a Schema

Each schema consists of the following elements:

- **DTO Definition**  
  Specifies the fields and data types that the document must have.

- **Generator (Generator)**  
  Defines the rules for filling fields when creating a new document.

- **Validator (