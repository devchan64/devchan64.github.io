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

---

# Part 2. Designing Data Isolation and Authorization for an IoT SaaS

This section is not just a theoretical model. It is a record of a **multi-tenancy** and **authorization** structure that was exercised while building and operating an actual IoT monitoring SaaS.

The current version has the following characteristics:

- **A document-centered data model**
  - All data is managed as independent documents with `tenantId`, `schemaName`, and `refId`.
  - Schema-driven DTOs and validators enforce both structure and meaning.
  - Even when tree-like data is needed, oversized single documents are avoided by splitting the data across multiple documents.

- **Tenant hierarchy modeled like directories**
  - A tenant has `tenantId`, `parentTenantId`, and `lineage` such as `/root/brandA/shop001`.
  - That allows the structure to express **parent-tenant to child-tenant monitoring** naturally.
  - Even so, the data itself always belongs only to its own `tenantId`, and access across levels is controlled only by **role scope**, not by tree membership alone.

- **A combination of Role + Permission + Scope**
  - A role is a meaningful bundle of actions, such as `TenantViewer`, `TenantOperator`, or `DeviceMaintainer`.
  - A permission is defined as `action + resourceType + condition(scope)`.
  - `UserRole(userId, roleId, scopeTenantId, scopeType)` expresses which user can exercise which role in which tenant range.
  - `scopeType = EXACT | WITH_DESCENDANTS` supports a common pattern in which a parent tenant monitors all descendant tenants together.

- **Authorization flow that stays close to O(1)**
  - At login time or tenant-switch time, the system calculates `effectivePermissions(userId, tenantId)` and caches it.
  - At request time, the system checks authorization using only `userId + tenantId + permissionKey`.
  - As a result, even when the number of tenants and users grows, individual authorization checks remain close to O(1).

- **A unified device-to-tenant mapping rule**
  - Each device belongs to exactly one `tenantId`.
  - Every incoming piece of data, command, or log is validated against that `tenantId` before it is stored or exposed.
  - When the monitoring UI switches tenant context, only devices and documents belonging to that tenant are queried, while parent-organization users can see descendants through `WITH_DESCENDANTS`.

So far, this model has been operated and validated in **small multi-tenant environments with a limited number of devices**.

- At a single-tenant level, the document model and authorization model worked simply and intuitively.
- In environments with mixed parent-child tenants, `WITH_DESCENDANTS` worked for upper-level supervision scenarios.
- Role inheritance, cross-tenant reference, and policy inheritance are only **partially used** today and still require sharper modeling.

The rest of this section explains, using that current operating version as a baseline,

- what requirements had to be satisfied,
- what domain model was defined for documents, schemas, tenants, roles, and permissions,
- and how authorization services and IoT monitoring scenarios were designed.

---

## 1. Overview

This document explains how **multi-tenancy** and **authorization** can be designed and implemented in an IoT SaaS platform. The approach presented here is based on tested operational experience and reflects an attempt to unify tenant structure, a document-centered data model, a role/permission system, and IoT device mapping into one coherent structure.

It centers on three goals:

1. **Complete isolation by customer or organization**
   Each tenant must own an independent data space, and data from different tenants must never mix or leak.

2. **A flexible document-centered model**
   Device state, settings, profiles, recipes, and user logs should all be manageable as documents, while schemas provide structural stability and validation.

3. **A scalable authorization model**
   Even as the number of tenants and users increases, authorization must remain cheap enough to evaluate, while still expressing complex SaaS operational scenarios through roles and permissions.

Together, that means the structure aims to go beyond simple RBAC and become **an architecture for domain isolation and authorization** that covers tenant hierarchy, document modeling, and IoT device routing in one system.

The following sections explain the flow of **requirements → domain model → isolation strategy → authorization model → operating scenarios → scalability structure**.

---

## 1.5 The Concept of a Tenant

In this document, the word **tenant** refers to a **logical unit of data partitioning** defined so that organizational data can be separated clearly.

At a basic level, a tenant exists for the following reasons:

- It creates a fully separated area so that data from different organizations never mixes.
- Every major entity such as users, devices, and documents belongs to exactly one tenant.
- It can be arranged hierarchically, like a directory tree.

### Why view a tenant like a filesystem directory?

This design defines tenant structure in terms that resemble a **filesystem directory tree** for three reasons.

1. **Clarity of isolation**
   - Just as files in different directories do not mix, each tenant remains separate from every other tenant.

2. **Scalability and intuition**
   - When organizations have parent-child structure, expressing them with paths such as `/root/organizationA/branch001` provides both structural consistency and intuitive understanding.

3. **Simple policy and inheritance modeling**
   - A tree structure makes it easy to describe "an upper organization can monitor a lower organization" using a scope such as `WITH_DESCENDANTS`.

### What information does a tenant contain?

A tenant includes properties such as:

- `tenantId`: the unique identifier of the tenant
- `parentTenantId`: the identifier of the parent tenant
- `lineage`: the path from root to the current tenant, for example `/root/orga/sub1`
- base metadata such as `name`, `type`, and `status`

### Why tenants matter so much in this document

Most of the design starts from the following principles:

- Every data model, including **documents, users, devices, and logs**, must belong to exactly one tenant.
- Every authorization decision is evaluated in the context of **which tenant's data is being accessed**.
- Whether a parent organization can manage child-organization data is controlled only through **role and scope**.

That makes the tenant both **the basic unit of data isolation** and **one of the main axes of the authorization model**.

---

## 2. Requirements

To design data isolation and authorization for an IoT monitoring SaaS, the required behavior must first be defined in both functional and non-functional terms.

### 2.1 Functional Requirements

#### 1) Independent management by tenant

- Each organization must be represented as an independent tenant.
- Data from different tenants must be completely separated by default.

#### 2) User–Tenant–Role structure

- A user must be able to relate to one or more tenants.
- Roles must be assigned per tenant.
- Roles define access rights over resources such as documents, devices, and configuration.

#### 3) Document access control

- A user must be able to read, write, or manage specific document schemas according to role.
- Authorization must be granular enough to operate at the schema level, document-type level, or particular resource level.

#### 4) Device-level access control

- A user must be able to have access to a specific device or device group.
- Device data such as logs, state, and commands must remain accessible only within the tenant that owns the device.

#### 5) Support for upper/lower organization structure

- A parent organization must be able to monitor child organizations when needed.
- But access must be governed by **role and scope**, not automatically by the existence of a tenant hierarchy.
- Base rules:
  - Child organizations cannot read parent data by default.
  - Parent organizations can monitor descendants only when a permitted scope is explicitly assigned.

### 2.2 Non-Functional Requirements

#### 1) Authorization performance

- Authorization should be evaluated in **close to O(1) time per request**.
- Performance should remain stable even with many tenants, users, and roles.

#### 2) Scalability

- As tenant, user, and device counts grow, the authorization service should scale in a controlled and mostly linear way.
- Cache and tenant-structure lookups must work efficiently in distributed environments.

#### 3) Stability under model change

- Changes to schema, permission structure, or tenant hierarchy must remain safe to roll out.
- Schema changes must support versioning and either automatic or manual migration for existing data.

#### 4) Correct tenant routing for IoT data

- Incoming IoT data such as logs, state updates, and commands must be assigned to the correct tenant at the protocol level.
- Defensive design must prevent data from ever being mixed into the wrong tenant.

---

## 3. Domain Model

The IoT SaaS isolation structure is built by combining multiple entities such as Document, Schema, Tenant, User, Role, and Permission. This section defines the core domain model and explains how each part contributes to isolation and authorization.

---

### 3.1 Document Model

Most data in this design is stored as a **document**. A document acts as the common unit for things like device state, recipes, profiles, logs, and settings.

#### Common properties of a document

Every document includes:

- `tenantId`
  - The tenant that owns the document. This is the first line of data isolation.

- `schemaName`
  - The schema that defines the structure and meaning of the document.

- `refId`
  - A globally unique reference ID for the document.

- `payload`
  - The actual data content, validated through schema DTOs and validators.

- `meta`
  - Additional metadata such as author, creation time, change history, and version.

#### Design principles

1. **A document can only be created if a schema exists for it.**
   Arbitrary untyped structures are not allowed.

2. **Document references are always expressed as `(schemaName, refId)`.**
   Path-based or implicit tree references are not allowed, and dependencies remain explicit.

3. **Tree structure should be composed by splitting documents when necessary.**
   Deep trees should not be embedded into a single document if they can be expressed as a loose multi-document structure.

This keeps the model **strongly structured while still remaining flexible**.

---

### 3.2 Schema and DTO

A schema is the contract that defines the **structure**, **data types**, and **semantic constraints** of a document.

#### Components of a schema

Each schema includes:

- **DTO definitions**
  - Field definitions and their types.

- **Generator**
  - Rules for populating required fields when new documents are created.

- **Validator**
  - Validation rules used on create and update.

#### Schema change and version management

Schemas evolve over time. The following principles apply:

- New schema versions are managed by combinations such as `schemaName + version`.
- Existing documents can be migrated automatically or manually.
- Where backward compatibility is not needed, versions should branch explicitly.

---

### 3.3 Tenant and Hierarchical Structure

A tenant is the basic unit of organization-level data isolation, and it can expand into a hierarchical tree like a filesystem directory.

#### Core properties of a tenant

- `tenantId`
  - A unique tenant identifier.

- `parentTenantId`
  - The parent tenant ID. The root tenant uses `null`.

- `lineage` or `path`
  - The path from the root to the current tenant, such as `/root/orga/sub1/unit3`.

- Metadata such as name, type, and status.

#### Principles of data isolation

1. **If `tenantId` differs, the data is always separated.**
   This applies to documents, devices, configuration, and logs.

2. **Parent-child relationship does not automatically grant access.**
   Access is always controlled by **role + scope**.

3. **Cross-tenant references are allowed only explicitly.**
   For example, a parent organization might expose a common profile document to child organizations in read-only form.

This structure preserves a simple isolation model while allowing hierarchical monitoring to be added flexibly.

---

### 3.4 User, Role, and Permission

At the center of authorization sits the relationship among users, roles, and permissions.

#### User

- A user has one global `userId`.
- A user can relate to one or more tenants.
- A user can hold different roles in different tenants.

#### Role

A role is a bundle of actions.

Examples:

- `TenantViewer`
  - Can read documents in a given tenant.

- `TenantOperator`
  - Includes part of the write surface, such as configuration changes and device control.

- `DeviceMaintainer`
  - Holds maintenance rights over a particular set of devices.

#### Permission

A permission is defined through:

- `action` such as READ, WRITE, EXECUTE
- `resourceType` such as DOCUMENT, DEVICE, CONFIG
- `scope conditions` such as schema name, device group, or specific refId

Examples:

- `DOCUMENT:READ:SCHEMA=BREW_PROFILE`
- `DEVICE:COMMAND:SCOPE=OWNED_BY_TENANT`

#### Role–Permission relationship

- Each role contains multiple permissions.
- A role may optionally have a parent role.
- A user's final permission set is the composition of the permissions in the assigned role plus inherited parent-role permissions.

#### User–Role assignment

When assigning a role to a user, the stored structure includes:

- `userId`
- `roleId`
- `scopeTenantId`
- `scopeType`
  - `EXACT`: valid only within that tenant
  - `WITH_DESCENDANTS`: valid in that tenant and all of its descendants

This lets one user hold different permissions depending on organization and scope.

---

## 4. Data Isolation Strategy

The most important goal in a multi-tenant IoT SaaS is **ensuring that data from different organizations never mixes**. This section defines isolation at the tenant level, the rules for references between documents, and the strategy for keeping device, log, and status data safely partitioned.

---

### 4.1 Tenant-Level Isolation

The core isolation rules are as follows.

#### 1) Every piece of data must belong to exactly one tenant

That includes:

- IoT device data such as state and logs
- documents
- configuration
- profiles and recipes
- user event logs

Every one of these entities must contain `tenantId` at creation time.

#### 2) Device-to-tenant mapping follows a single rule

Each device belongs to one `tenantId`. All device data goes through the following sequence:

1. Read the `tenantId` contained in the incoming packet
2. Verify that the tenant is valid
3. Store the data only in the storage area for that tenant

This prevents data from being routed into the wrong tenant in the first place.

#### 3) Storage choices: logical isolation vs physical isolation

Tenant-based data isolation can expand into two scenarios:

- **Logical isolation within one database**
  - All tenant data lives in one DB and is separated by `tenantId`.

- **Physical separation by tenant**
  - Large customers or regulated environments may receive an isolated schema, database, or instance.

This document assumes logical isolation by default while keeping the `tenantId`-based model consistent enough to later support physical separation.

---

### 4.2 Reference Rules Between Documents

When a document-centered data model is used, one document often needs to reference another. The following rules keep that from breaking tenant isolation.

#### 1) Default rule: only same-tenant references are allowed

- If document A references document B, both documents must have the same `tenantId`.
- This can be enforced at the schema level.

#### 2) Exception: limited references in parent/child organization structures

In some operating scenarios, a parent organization must provide a common document, such as a shared recipe or shared device setting, to child organizations.

That can be allowed only if:

- the schema explicitly declares cross-tenant read-only allowance,
- the allowed direction is only parent → child,
- only read access is permitted, not update or delete.

This keeps **operational flexibility without abandoning isolation**.

#### 3) References must always use `(schemaName, refId)`

Path expressions, composite keys, and embedded tree references are not used.

- Every document reference must be expressed as a pair of `schemaName` and `refId`.
- This keeps documents independent and reusable.

---

## 5. Authorization Model

To complete tenant-based isolation, the system needs an authorization structure that decides whether access should be allowed at all. This section defines that model using User, Role, Permission, and Scope.

### 5.1 Basic Principles

Authorization is evaluated using three core elements:

1. **userId**
   - The identity of the user making the request

2. **tenantId (contextTenantId)**
   - The tenant context the user is trying to access, such as the tenant selected in the monitoring UI

3. **permissionKey**
   - A key representing the requested action, for example:
     - `DOCUMENT:READ:SCHEMA=BREW_PROFILE`
     - `DEVICE:COMMAND:SCOPE=OWNED_BY_TENANT`

#### Tenant-based access principle

- To read or mutate data in a given tenant, a user must hold a role assigned either directly in that tenant or through the scope of an ancestor tenant.
- Parent → child monitoring can be allowed.
- Child → parent access is forbidden by default.
- Organizational access is controlled through **role and scope**, not merely by tree membership.

#### Core concept of scope

When assigning a role, scope defines in which tenant range the role can be exercised.

- `EXACT`
  - Valid only in the given tenant

- `WITH_DESCENDANTS`
  - Valid in that tenant and all descendants

This allows simple support for:

- parent organizations monitoring all descendants,
- granting limited roles only to one branch or store,
- keeping the permission model stable even when the tenant tree grows.

### 5.2 Effective Permissions Calculation

To process authorization in close to O(1), the system precalculates a user's role-derived permission set.

#### What are effective permissions?

They are the final set of permissions the user can actually exercise in a specific tenant context.

Example:
If user U has:

- `TenantOperator` with `EXACT` scope in tenant T, and
- `TenantViewer` assigned from an ancestor tenant with `WITH_DESCENDANTS`,

then the final authorization set in tenant T is the merged permission set from those roles and any inherited parent roles.

#### Calculation rules

Effective permissions are calculated by combining every applicable UserRole that satisfies:

1. `scopeType = EXACT`
   - include when `scopeTenantId === contextTenantId`

2. `scopeType = WITH_DESCENDANTS`
   - include when `contextTenantId` is a descendant of `scopeTenantId`

3. collect every permission from each included role

4. flatten parent-role inheritance if present

#### When is it calculated?

- At login
- When the user switches tenant context
- When role or permission changes invalidate the cache

#### Actual request flow

1. The client or server identifies `userId` and `tenantId` from headers or context.
2. The authorization service reads the cached `effectivePermissions(userId, tenantId)`.
3. It checks whether the requested `permissionKey` is present.
4. If present, Allow. Otherwise, Deny.

#### Performance benefit

- The request path only performs a **set-membership check**.
- That keeps authorization cost close to O(1).
- As user and tenant counts grow, load increases in a controlled way.

---

## 6. Authorization Service Design

To operate the permission and isolation model safely in a real system, a dedicated **authorization service** is needed. It manages user-tenant-role relationships and provides fast authorization decisions to the rest of the platform.

### 6.1 Roles and Responsibilities

The authorization service handles the following work.

#### 1) Reading user–tenant–role relationships

- It determines which roles a given `userId` holds in which `scopeTenantId`.
- It also checks whether the scope is `EXACT` or `WITH_DESCENDANTS`.

#### 2) Managing Role and Permission definitions

- Creating, updating, and deleting roles
- Managing the permission set attached to each role
- Optionally managing parent-child relationships between roles

#### 3) Verifying scope on top of the tenant hierarchy

- To decide whether a `WITH_DESCENDANTS` role is valid in a given context, the service must determine quickly whether one tenant is below another.
- That can be implemented using tenant lineage or other precomputed ancestry information.

#### 4) Calculating and caching effective permissions

- For each `userId + tenantId`, the service computes the actual usable permission set.
- That result is cached so request-time checks can remain O(1).

#### 5) Serving authorization checks for external services

Web apps, API servers, and IoT gateways can ask questions such as:

- "Does this user have this permission in this tenant?"
- "What are all the permissions this user has in this tenant?"

### 6.2 Major API Examples

The authorization service can expose APIs through REST, gRPC, or other RPC mechanisms.

#### `POST /authz/evaluate`

Evaluates whether a specific permission is allowed.

**Input**

```json
{
  "userId": "user-123",
  "tenantId": "tenant-A1",
  "permissionKey": "DOCUMENT:READ:SCHEMA=BREW_PROFILE"
}
```

**Output**

```json
{ "allow": true }
```

#### `GET /authz/effective-permissions`

Returns the full permission set the user can exercise in a given tenant context.

**Example input**

```text
/authz/effective-permissions?userId=user-123&tenantId=tenant-A1
```

**Output**

```json
{
  "permissions": [
    "DOCUMENT:READ:SCHEMA=BREW_PROFILE",
    "DOCUMENT:WRITE:SCHEMA=DEVICE_CONFIG",
    "DEVICE:COMMAND:SCOPE=OWNED_BY_TENANT"
  ]
}
```

#### `POST /authz/roles`

Creates a new role or updates an existing one.

**Example input**

```json
{
  "roleId": "TenantOperator",
  "permissions": [
    "DOCUMENT:READ:SCHEMA=BREW_PROFILE",
    "DOCUMENT:WRITE:SCHEMA=BREW_PROFILE",
    "DEVICE:COMMAND:SCOPE=OWNED_BY_TENANT"
  ],
  "parentRoleId": "TenantViewer"
}
```

#### `POST /authz/user-roles`

Assigns a role to a user.

**Example input**

```json
{
  "userId": "user-123",
  "roleId": "TenantOperator",
  "scopeTenantId": "tenant-A1",
  "scopeType": "WITH_DESCENDANTS"
}
```

This is one of the core APIs for enabling parent organizations to monitor descendants.

### 6.3 Cache Strategy

Authorization latency directly affects the response time and scalability of the entire service. For that reason, the strategy for caching `effectivePermissions(userId, tenantId)` must be explicit.

#### 1) Cache storage location

One or both of the following can be used:

- **In-memory cache inside the authorization service**
  - Fastest possible reads, appropriate for single-instance or very hot local workloads.

- **External cache such as Redis**
  - Recommended when multiple authorization-service instances run and cache consistency matters.

#### 2) Cache key structure

Cache keys are based on user and tenant context:

```text
effective:{userId}:{tenantId}
```

Example:

```text
effective:user-123:tenant-A1
```

This cleanly separates the fact that the same user may have different effective permissions in different tenant contexts.

#### 3) Cache invalidation

When permission, role, or tenant information changes, cached results become invalid and must be recalculated.

The following events require invalidation:

- **UserRole changes**
  - A role is added to or removed from a user
  - Scope fields such as `scopeTenantId` or `scopeType` change

- **Role changes**
  - The role's permission set changes
  - Parent-child role structure changes

- **Tenant hierarchy changes**
  - `parentTenantId` changes
  - tenant move or merge happens
  - the interpretation of `WITH_DESCENDANTS` changes

Possible invalidation scopes include:

- invalidating only the affected user-tenant cache key
- invalidating all effective-permission cache entries for the affected user
- in larger environments, invalidating all users related to the affected tenant line

#### 4) Version-based cache validation

In larger environments, cache invalidation can also be supported through versioning.

##### Permission version strategy

- Maintain `permissionVersion` values per user or per role.
- Store the version along with the cache entry.
- At authorization time, if the current version and the cached version differ, drop the entry and recalculate.

Benefits:

- avoids explosive global invalidation,
- limits recalculation to the changed user or role.

#### 5) TTL options

TTL may optionally be used.

- Short TTLs are safer in environments with weaker change propagation.
- Long TTLs or no TTL can be beneficial in stable environments where performance matters more.

This document recommends **explicit invalidation plus version validation** as the primary strategy.

---

## 7. Example IoT Monitoring Scenarios

The tenant structure, document model, and authorization model described so far need to be understandable in concrete operating terms. This section walks through three representative scenarios.

### 7.1 Device–Tenant Mapping

Every IoT device (`deviceId`) must belong to exactly one tenant. That is the core assumption behind safe data isolation.

#### 1) Assign a tenant when the device is registered

A device is registered with information such as:

- `deviceId`
- `tenantId`
- metadata such as model, serial number, and installation site

Whenever the device connects or sends data, the server validates the included `tenantId` and confirms that the device belongs to the expected tenant.

#### 2) Validate tenant at data-ingestion time

The following data must all be validated and stored based on `tenantId` at receipt time:

- real-time state reports
- sensor data
- error and log data
- command responses

The server determines storage destination based on `tenantId` and never writes the data into another tenant's area.

#### 3) Prevent invalid tenant data

By explicitly carrying `tenantId` at the protocol level, the system can defend against misrouting or bad device behavior that would otherwise contaminate another tenant's data.

### 7.2 Flow in the monitoring UI

What a user sees in the web or mobile monitoring UI depends entirely on the tenant the user has selected.

#### Overall flow

1. **User logs in**
   - The system retrieves the list of tenants the user may access.

2. **A specific tenant context is activated**
   - For example, if user A can access `tenant-X1` and `tenant-X2`, choosing `tenant-X2` sets `contextTenantId = tenant-X2`.

3. **Effective permissions are calculated or loaded**
   - At login or tenant selection time, `effectivePermissions(userId, contextTenantId)` is read from cache.
   - If absent or invalid, it is recalculated and cached.

4. **The UI is rendered based on authorization**
   - Documents without read permission are hidden.
   - Configuration pages without write access are disabled.
   - Device-control buttons are shown only if the required permission is present.

5. **Data is queried**
   - The system reads devices, profiles, recipes, and logs that belong to the selected tenant.
   - The server returns data based on `contextTenantId`, not only on `userId`.

6. **Request-level authorization is enforced**
   - When the user opens or edits a document, the service immediately checks the relevant `permissionKey`.

### 7.3 Parent organizations monitoring child organizations

The model supports scenarios where an upper-level organization monitors all lower-level organizations together.

#### Example: a parent-organization user viewing all child organizations

1. User U in the parent organization has:

   - `roleId = TenantOperator`
   - `scopeTenantId = parent organization`
   - `scopeType = WITH_DESCENDANTS`

2. User U chooses a specific child tenant in the UI.

3. The authorization service verifies:

   - the role has `WITH_DESCENDANTS`,
   - and the chosen child tenant is indeed a descendant of the scope tenant using lineage or the tenant tree.

4. If the conditions hold, the user can read documents, devices, and logs belonging to that child tenant.

#### Directional access rules

- **Parent → child**
  - allowed only when `WITH_DESCENDANTS` is present

- **Child → parent**
  - not allowed by default
  - allowed only by explicit exception policy, such as read-only access to shared policy documents

#### Benefits

- Even when the hierarchy becomes deep, the authorization model stays simple.
- Even after organizational restructuring, a scope-based model remains structurally stable.

---

## 8. Versioning and Scalability

In a multi-tenant IoT SaaS, both the data model and the permission structure are likely to evolve over time. Schema, roles, and tenant structure must be able to change without destroying system consistency. This section covers long-term **versioning strategy** and **scalability considerations**.

### 8.1 Schema Versioning

Document schemas will continue to grow and change. To keep compatibility while allowing evolution, follow the principles below.

#### 1) Manage schemas by `schemaName + schemaVersion`

- Even within the same functional group, adding new structure or fields should increase the version number.
- Example:
  - `BREW_PROFILE:v1`
  - `BREW_PROFILE:v2`

#### 2) Record the schema version used when the document was created

- A field such as `meta.schemaVersion` should show exactly which version created the document.

#### 3) Establish a migration policy when the schema changes

- If automatic conversion is possible, use transformers inside the system.
- If automatic conversion is not possible, perform gradual manual migration during operation.
- Large schemas may be better handled by introducing the new schema first and migrating gradually.

This preserves system consistency even when schema change is frequent.

### 8.2 Role / Permission Versioning

Roles and permissions also change. Features can disappear or be added, which changes both permission definitions and role composition.

#### Recommended approach

1. Prefer **adding a new role definition** rather than mutating the old one in place
2. Prefer **adding a new permission key** rather than mutating an existing one
3. Reassign users gradually over time
4. Mark old roles deprecated and remove them only after a safe transition period

This reduces role collision and permission confusion during live operation.

### 8.3 Expansion of the Tenant Hierarchy

Operationally, the tenant tree can change in many ways:

- new organizations or branches added
- merges between organizations
- parent-child relationships updated
- deeper tree structures introduced

The following principles help absorb those changes safely.

#### 1) Keep tenant `lineage(path)` up to date

Whenever tenants move or merge:

- regenerate `parentTenantId`,
- and regenerate `lineage` consistently.

#### 2) Reinterpret `WITH_DESCENDANTS` using lineage automatically

If the tenant tree changes, scope validity should shift automatically through the updated lineage relationships.

#### 3) Invalidate cache

Any tenant move or merge must invalidate cached effective-permission results.

### 8.4 Scalability Considerations

As the number of tenants, users, and devices grows, authorization and data access still need to remain stable.

#### 1) Large numbers of tenants

Even if tenant hierarchy becomes deep or scales to hundreds or thousands of nodes, ancestor/descendant checks can be performed through **lineage prefix comparison** alone.

- Tenant paths are represented as lineage strings like `/root/orgA/sub1`.
- Determining whether one tenant is an ancestor of another becomes a prefix check.
- Since path depth is limited, the cost remains **close to O(1) or O(depth)**.

#### 2) Large numbers of users

Per request, the work is bounded:

- effective-permission calculation happens only at login or tenant-switch time,
- request-time checks stay O(1),
- cache-backed design supports high-load environments.

#### 3) Large numbers of IoT devices

- Device-to-tenant mapping remains simple because every device belongs to one tenant.
- Queries remain bounded because the normal access pattern is always tenant-scoped.

#### 4) Ability to expand into physical isolation

- The system can begin with logical isolation through `tenantId`.
- Later, when large customers or regulatory requirements demand it, the deployment can move to per-tenant schemas or databases.
- Because the document model and authorization model stay the same, that transition cost remains relatively low.

### 8.5 Summary of Long-Term Operating Principles

- **Prioritize abstraction**: keep schema, document, and role structures behind explicit abstraction layers
- **Separate responsibilities**: tenant isolation, authorization, IoT ingestion, and UI should remain decoupled
- **Design for extension**: hierarchy, permissions, and document structures should all be extendable
- **Change safely**: versioning and cache invalidation should be explicit enough to avoid operational confusion
- **Control by policy**: parent/child access should be governed by policy and scope, not by structure alone

---

## 9. Operations and Monitoring

If data isolation and authorization are to stay reliable in a multi-tenant IoT SaaS, the system must be observed continuously during operation. This section summarizes the main signals, logs, and response concerns that should be monitored.

### 9.1 Managing authorization-failure logs

Authorization failures are important signals for identifying bad access attempts, configuration issues, bad role assignments, or tenant-boundary problems.

#### 1) Information that must be logged on authorization failure

- `userId`
- `contextTenantId`
- `permissionKey`
- failure type, such as missing permission, unmet scope, or schema restriction
- request URL and HTTP method
- timestamp

These logs make it possible to determine:

- which user lacked which permission,
- whether role configuration is wrong,
- whether cache is stale after tenant-structure changes,
- whether devices or apps are targeting the wrong tenant.

#### 2) Automatic alerting

Persistent authorization failures may indicate either a security threat or an operational misconfiguration. Alerts can be triggered for:

- repeated failures for the same user
- many failures in a short period within a particular tenant
- broad spikes in denial for a specific `permissionKey`
- increases in `WITH_DESCENDANTS`-related scope errors

### 9.2 Audit logs for tenant/role/permission changes

Permissions and tenant structure are security-sensitive. All of the following should be audited:

#### 1) Events that must be recorded

- role creation, update, deletion
- permission-set changes
- UserRole assignment and revocation
- tenant hierarchy changes, such as `parentTenantId` updates, moves, and merges
- schema-version changes or document-structure changes

#### 2) Information included in the logs

- actor (`userId`)
- target (`roleId`, `userId`, `tenantId`, etc.)
- before and after values
- timestamp
- the change path, such as API or admin UI

These logs are critical when tracing permission issues or responding to security events.

### 9.3 Cache monitoring

The stability of the effective-permissions cache is directly tied to authorization performance.

#### 1) Metrics that should be monitored

- **cache hit ratio**
  - a low hit ratio means more load on the authorization service

- **frequency of effective-permissions recalculation**
  - if recalculation happens too often, role or scope changes may be too frequent, or invalidation may be too aggressive

- **cache size and memory usage**
  - the number of cached entries may grow with user count and must be observed

#### 2) Monitoring for version-based validation

- frequency of `permissionVersion` mismatches
- cache regeneration time
- re-interpretation rates caused by lineage changes

Abnormal growth in those numbers usually signals heavy churn in tenant structure or permission models.

### 9.4 Monitoring IoT data operations

The tenant-isolation model must also be monitored at the IoT device layer.

#### 1) Detecting bad tenant data ingress

- detect whether the same device sends requests under different `tenantId` values
- raise alerts on `tenantId` mismatch
- compare registered device information with the tenant carried by real incoming traffic

#### 2) Monitoring missing data and excessive traffic

- identify tenants whose IoT data suddenly drops or grows abnormally
- track device connectivity state and reporting cadence together with data-volume changes

### 9.5 Operational metrics

Problems in authorization and organizational structure can delay real business operations, so the following metrics should be monitored continuously.

#### 1) Authorization latency

- average authorization time
- p95 to p99 latency
- whether the O(1)-style access path is still holding in practice

#### 2) Impact of organizational-structure changes

- failures during lineage regeneration after tenant moves or additions
- correctness of scope application after those changes

#### 3) Impact on UI and workflow

- whether menus or features are being hidden or exposed unexpectedly in a given tenant
- whether incorrect permission settings block normal business work

### 9.6 Combined operating principles

- Interpret authorization failures not as simple errors, but as **signals of anomalies in security, policy, or organization structure**
- Track all user, role, and tenant changes with audit logs
- Verify periodically that the lineage-based tree model and scope application still behave correctly
- Treat cache hit ratio and authorization latency as core service-stability metrics
- Treat IoT `tenantId` mismatches as urgent anomalies that require immediate handling

---

# Part 3. Additional Design Philosophy and Future Work

This section exists to record more explicitly

- what line of reasoning led to the earlier design,
- why this direction is desirable,
- and what still remains unresolved.

The current model feels viable, but documenting the basis, limits, and expansion conditions behind that intuition is useful for future architecture changes and operational planning.

## 1. Why view tenants as directories?

The overall design grew naturally from the following analogy:

- **Tenant = directory tree**
- **Role / Permission = directory ACL**
- **ABAC = attribute-based conditions layered over ACL**

That analogy works well for the following reasons.

### 1.1 It makes the isolation model simple and intuitive

The rules of directory structure map cleanly to the needs of an IoT SaaS:

- Data between tenants remains completely separate.
- Parent-child relationship can exist without automatic access.
- A path-based representation makes ancestor and descendant relationships explicit.

That fits the SaaS requirement of **hierarchical monitoring combined with strict isolation**.

### 1.2 It lets ACL-style access control be reused naturally

- The directory ACL idea of “this user or group has R/W/X rights here” is nearly the same abstraction as role plus permission.
- Directory inheritance can be mapped into RBAC through `scopeType(EXACT / WITH_DESCENDANTS)`.

### 1.3 It lets ABAC be added only where needed

As with Windows ACLs, allowing ABAC too broadly can explode the rule set and increase operational difficulty.

For that reason, this design keeps the following principles:

- use RBAC as the base structure
- use tenant hierarchy and scope for first-level access range control
- introduce ABAC only in limited, necessary cases

---

## 2. Additional Notes on Data-Structure Choices

### 2.1 Why design tenant structure like a directory?

The combination of `tenantId`, `parentTenantId`, and `lineage(path)` satisfies the following goals:

- ancestor/descendant checks can be done through prefix comparison rather than recursive graph traversal
- when tenants move or merge, policy interpretation can be refreshed by regenerating lineage
- tenant attributes remain easy to read if ABAC is later layered in

A lineage-prefix approach keeps tenant-relationship checks **close to O(1) or O(depth)**.

### 2.2 Keep role inheritance shallow

If role inheritance grows deep:

- permission conflict becomes more likely
- flatten cost grows
- operators struggle to understand what a role actually means

In most practical environments, shallow inheritance such as `TenantViewer → TenantOperator → TenantOwner` is the most realistic form.

### 2.3 UserRole(scope) is the key that connects the full model

By placing `scopeTenantId + scopeType` inside UserRole, the model can naturally express:

- parent-organization monitoring
- restriction to one child organization
- activation of permissions only within a particular tenant range

This is effectively the formal data-model expression of whether a directory ACL should inherit downward.

---

## 3. Authorization Flow and Performance Design

### 3.1 Do not traverse the graph on every request

Computing tenant hierarchy and role inheritance on every request does not scale well.

The preferred approach is:

1. calculate everything at **login time**
2. or calculate everything at **tenant-switch time**

Then request-time work becomes:

- load `effectivePermissions(userId, tenantId)`
- check whether `permissionKey` exists in the set

That keeps authorization cost **effectively O(1), even in large IoT environments**.

### 3.2 Keep ABAC as a thin layer on top of RBAC

ABAC has high expressive power, but it can also cause:

- policy explosion
- hard debugging
- operational confusion

For that reason, the structure should remain:

1. RBAC grants first-level access
2. ABAC policy evaluates conditions
3. the final allow/deny decision is made

---

## 4. Why It Already Works Well in Small Environments

The current structure is intuitively sound and performs well in small environments for simple reasons:

- there are few tenants, so prefix checks are cheap
- role inheritance is shallow, so flatten cost is small
- UserRole counts are still small, so effective-permission calculation is fast

As the scale grows, the expected pressure points are:

- more tenants → need for lineage and prefix optimization
- more roles and permissions → higher flatten cost and harder cache invalidation
- more ABAC rules → higher condition-evaluation cost
- more UserRoles → larger effective-permission caches and more cache-management strategy

So the current structure is valid, but the future scaling concerns are already visible.

---

## 5. Open Problems

### 5.1 Defining the scope of tenant inheritance

- Which settings or documents should be inherited from parent to child?
- Can child tenants override inherited documents?
- How much cross-tenant read-only policy should be allowed?

### 5.2 Deciding the depth of role inheritance

- Shallow inheritance is realistic today,
- but deeper inheritance may become necessary as the feature set grows.
- Whether parent permissions can be overridden also remains unsettled.

### 5.3 Strategy for invalidating authorization cache

`effectivePermissions` cache invalidation is one of the hardest expansion problems.

- UserRole changes
- RolePermission changes
- Tenant lineage changes

All of these can trigger invalidation, and in larger environments the invalidation cost itself can become a bottleneck.

### 5.4 Whether ABAC should expand further

Possible additions include:

- region and tier conditions
- conditional read and write
- document-type-specific ABAC policy

ABAC needs to grow gradually, if at all.

### 5.5 Cross-tenant document-sharing policy

- Should a parent tenant distribute common documents to children?
- How should the direction of reference be constrained?
- Should child organizations be allowed to override them?

---

## 6. Conclusion

The following conceptual frame maps very well to IoT SaaS data isolation and authorization:

- **Tenant = directory**
- **Role / Permission = ACL**
- **scope = directory inheritance structure**
- **ABAC = limited attribute-based conditions**

The current design already works well in small environments and has the foundation needed to scale into larger ones.

Even so, the following areas still need further refinement:

- depth of permission inheritance
- cache invalidation strategy during tenant moves and merges
- cross-tenant document policy
- the scope of ABAC expansion
- resolution of conflicts in role composition

In other words, the model is a valid first form, but one that will continue to need expansion and refinement as the service grows.
