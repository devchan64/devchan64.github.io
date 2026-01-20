---
date: 2026-01-20
layout: post
permalink: /en/2026/01/20/mdm-silent-install-solution-analysis.html
tags:
- Project
title: Analysis of Silent Install Solutions Using MDM
---

> `gpt-4-turbo` has translated this article into English.

---

# Analysis of Silent Install Solutions Using MDM

## 1. Purpose and Scope of the Document

### 1.1 Purpose of the Document

This document aims to analyze the **practical implementation possibilities, technical prerequisites, and operational strategies** for **Silent Install solutions using MDM (Mobile Device Management)**, focusing on Android-based kiosk and unmanned terminal environments.

Particularly, based on past experiences where implementing Silent Install became repeatedly challenging due to changes in Android security policies, the document aims to:
- **Clearly differentiate between officially sustainable methods and non-recommended/alternative paths** at the current time,
- Provide **realistic selection criteria** in commercial and industrial product environments.

This document is intended as a technical review material and a **decision support report** that can be utilized for architectural decisions, equipment selection, and operational cost estimation.

---

### 1.2 Scope of Analysis

The scope of analysis in this document includes:

- Concept and conditions for Silent Install on Android OS-based terminals
- Technical relationships between **MDM, Android Enterprise, and the Device Owner model**
- The role and limitations of **Zero-touch Enrollment**
- The impact of **security policy changes across Android versions** on Silent Install
- Operational strategy differences between **commercial products with GMS** and **industrial products without GMS**
- Conditions requiring **AOSP custom builds** and the associated costs and operational risks
- Technical limitations and practical failure factors of **rooting-based approaches**
- Classification and comparison of Android-based MDM solutions considering costs

The analysis primarily focuses on **store kiosks, unmanned terminals, and mass deployment environments**, excluding user installation scenarios on personal devices for general consumers.

---

### 1.3 Analysis Target Scenarios

The main scenarios covered in this document include:

- Operation of retail kiosks using commercial terminals with GMS
- App installation and updates without user consent via MDM
- Environments considering security, maintenance, and scalability for long-term operation
- Examination of AOSP-based operational strategies when using industrial terminals

---

### 1.4 Non-Analysis Targets and Exclusions

The following items are excluded from the scope of analysis in this document:

- General app distribution methods targeting personal user devices
- Installation models based on Play Store user approvals
- Illegal or security policy circumventing installation methods
- Non-operational environment at the PoC (Proof of Concept) level
- Feature introductions centered on specific MDM vendor marketing

This document only analyzes paths that are **officially supported and viable for long-term operation**.

---

### 1.5 Target Audience for the Document

The primary audience for this document includes:

- Technical leaders designing Android-based kiosk architectures
- Operational and procurement personnel selecting terminals and MDM solutions
- Project leaders assessing the need for AOSP custom builds or MDM adoption
- Engineers managing operational risks associated with security policy changes

Through this, the document aims to serve as a **standard reference that satisfies both technical accuracy and operational realism**.

## 2. Core Keywords and Definitions

In this section, we define the core keywords and terms used throughout this document.  
Each term is explained not in its general dictionary sense but specifically within the context of **Android kiosk and Silent Install operations**.

---

### 2.1 MDM (Mobile Device Management)

MDM refers to a management system used by organizations to centrally register, configure, control, and monitor mobile devices they own or manage.

In the context of Android kiosks, MDM performs the following roles:

- Register devices as **Device Owners**
- Enforce OS-level policies
- Centrally manage app installation, updates, and removal
- Set and maintain Kiosk mode
- Apply security policies and restrictions

In this document, MDM refers to a **management solution that utilizes Device Owner privileges based on Android Enterprise**.

---

### 2.2 Silent Install

Silent Install refers to the method of remotely installing or updating applications by a managing entity without any user approval UI, installation confirmation pop-ups, or permission request screens.

In this document, Silent Install is defined under the following conditions:

- Based on Android Enterprise
- Performed under Device Owner privileges
- Uses Managed Google Play or an equivalent official path

Installation methods involving ADB, rooting, or API calls that bypass official channels are not defined as Silent Install here.

---

### 2.3 Device Owner

Device Owner is a management authority model that declares an Android device as **organization-owned (Corporate-Owned)**.

When Device Owner privileges are granted, the following are possible:

- App installations and updates without user intervention
- Enforcement of Kiosk mode
- Control over system settings, network, and security policies
- Full administrative rights over the device

Silent Install is not feasible without Device Owner privileges.

---

### 2.4 Android Enterprise

Android Enterprise is an official management framework provided by Google for securely managing Android devices in corporate and organizational environments.

Android Enterprise includes:

- Device Owner / Profile Owner management models
- Managed Google Play
- Zero-touch Enrollment
- Kiosk (Dedicated Device) scenarios

This document treats **Android Enterprise as a prerequisite for Silent Install**.

---

### 2.5 GMS (Google Mobile Services)

GMS refers to the package of core services provided by Google, including Google Play Services and the Google Play Store.

The inclusion of GMS directly impacts:

- The usability of Managed Google Play
- The supportability of Android Enterprise
- The feasibility of Silent Install via MDM

In this document, devices with GMS are categorized as **commercial products**, and those without are categorized as **industrial products**.

---

### 2.6 AOSP (Android Open Source Project)

AOSP refers to the open-source base of the Android operating system that Google has made public.

Operating on an AOSP base has the following characteristics:

- Does not include GMS
- Cannot use Android Enterprise or Managed Google Play
- Allows OS-level customization
- Includes apps and frameworks in the system distribution

This document discusses AOSP as an **alternative choice for industrial devices without GMS**.

---

### 2.7 Rooting

Rooting refers to the act of obtaining administrative rights over the system area on an Android device.

Rooting can potentially allow the following tasks:

- Modification of system files
- Calling restricted APIs
- Using unofficial installation paths

However, this document defines rooting as a **non-recommended method from an operational, security, and maintenance perspective**, and does not recognize it as a formal solution for Silent Install.

---

### 2.8 Commercial Products

Commercial products refer to Android devices sold in the general consumer market, **including GMS and certified by Google**.

Their characteristics include:

- Support for Android Enterprise
- Possibility of MDM integration
- Feasibility of Silent Install
- Suitability for long-term operation

This document uses commercial products as the baseline premise for retail kiosks.

---

### 2.9 Industrial Products

Industrial products refer to devices manufactured for specific purposes such as kiosks, equipment control, and factory/field equipment.

Their general characteristics include:

- Lack of GMS
- Non-support of Android Enterprise
- Limited MDM functionality
- High likelihood of requiring AOSP custom builds

This document categorizes these as environments where **Silent Install cannot be implemented via MDM**.

---

### 2.10 Zero-touch Enrollment

Zero-touch Enrollment is a provisioning method that automatically registers devices to MDM upon their first boot without user intervention.

Zero-touch performs the following roles:

- Automatically acquires Device Owner status
- Supports mass device registration without human intervention
- Reduces initial setup costs

While it does not perform Silent Install by itself,  
Zero-touch Enrollment is defined as a **means to secure the prerequisites that enable Silent Install**.

---

## 3. Overview of Android Management Models

In this section, we outline the management models of the Android operating system, focusing on the structural background that enables Silent Install, primarily differentiating between general user environments and organizational management environments.

---

### 3.1 Basic Security Model of Android OS

Android fundamentally adopts a **user-centric security model**. The core premises of this model are as follows:

- The device owner is the individual user.
- Application installations and updates require explicit user consent.
- The system area and application area are strictly separated.
- Security policies are continuously strengthened to prevent malware, unauthorized installations, and misuse of permissions.

Under this basic security model, **application installation without user consent (Silent Install)** is fundamentally not permitted.

---

### 3.2 User-Owned Device Model

The user model is the default operating method for general consumer devices.

Its main characteristics include:

- Ownership of the device lies with the user.
- User approval is required for application installations.
- Only Play Store or explicitly permitted external installations are possible.
- Management authority is limited to the app level.

This model imposes the following restrictions:

- Silent Install is not possible.
- Enforcing OS-level policies is not possible.
- Full implementation of Kiosk mode is not possible.

This document uses the user model as the **baseline for Silent Install analysis**,  
but it is not considered the target model.

---

### 3.3 Corporate-Managed Device Model

The corporate-managed model is a management method predicated on the device being **corporate-owned (Corporate-Owned)** rather than personally owned.

The core features of this model are as follows:

- Device ownership is vested in the organization.
- The management entity controls the device from the initial registration.
- Application of OS-level policies is possible.
- App installations and updates can be performed without user intervention.

This management model is officially provided through **Android Enterprise**.

---

### 3.4 Android Enterprise-Based Management Model

Android Enterprise is Google's official framework designed to implement the corporate management model.

Android Enterprise provides the following management methods:

- **Device Owner (Fully Managed Device)**
- Profile Owner (Work Profile)
- Dedicated Device (Kiosk, COSU scenarios)

Among these, the focus of this document's analysis includes:

- **Device Owner**
- **Dedicated Device (Kiosk)**

Only under these models is Silent Install structurally permitted.

---

### 3.5 Device Owner-Centric Management Structure

The Device Owner model declares the device as corporate-owned, providing the highest level of management authority.

Key features of the Device Owner model include:

- Possession of full management authority over the device
- Capability to install applications without user approval
- Control over system UI, settings, network policies
- Enforcement and maintenance of Kiosk mode

Silent Install is based on Device Owner privileges and is performed through **official APIs and policy pathways**.

---

### 3.6 Relationship Between Management Models and Silent Install

The relationship between Android management models and Silent Install can be summarized as follows:

- User model  
  → Silent Install not possible
- Profile Owner model  
  → Limited management possible, not suitable for Silent Install
- Device Owner / Dedicated Device model  
  → Silent Install possible

Thus, the feasibility of Silent Install is **not a matter of Android version or workaround techniques but a choice of management model**.

---

### 3.7 Management Model Premises of This Document

This document proceeds with the analysis based on the following premises:

- Based on Android Enterprise
- Device Owner or Dedicated Device model
- Corporate-owned devices
- Central management through MDM

Outside these premises,  
Silent Install is considered neither technically nor policy-wise feasible.

---

## 4. Technical Definition of Silent Install

In this section, the technical meaning of Silent Install is clearly defined, and its differences from previous installation methods and similar concepts are distinguished.  
This strict delineation defines the scope of Silent Install used in this document.

---

### 4.1 Definition of Silent Install

Silent Install refers to the method of installing, updating, or reinstalling applications remotely by a management entity **without user approval UI, installation confirmation pop-ups, or permission request screens**.

The definition of Silent Install in this document must satisfy the following conditions:

- Management environment based on Android Enterprise
- The device registered as Device Owner or Dedicated Device
- Installation triggered by MDM policy
- Use of officially supported API and distribution pathways

Installation methods that do not meet these conditions are not defined as Silent Install.

---

### 4.2 Differences Between Silent Install and General Installation Methods

Silent Install differs from the general user installation method as follows:

| Aspect | General Installation | Silent Install |
|---|---|---|
| Installation Agent | User | Management Entity (MDM) |
| User Approval | Required | None |
| UI Display | Installation/Permission Screens Shown | No UI Display |
| Permission Granting | Manual User Approval | Automatic Based on Policy |
| Operation Target | Personal Device | Organization-Owned Device |

Silent Install is not a convenience feature but a result of management authority.

---

### 4.3 Official Pathway-Based Silent Install

The officially recognized pathway for Silent Install in Android includes:

- Android Enterprise
- Device Owner or Dedicated Device management model
- App distribution through Managed Google Play
- Application of MDM's "Required App" policy

This pathway is not an exception to Android security policies but a **designated normal operation pathway for organizational management scenarios**.

---

### 4.4 Distinction From Unofficial Installation Methods

The following methods, previously misconceived as Silent Install, are not defined as such in this document:

- Unattended installation using ADB
- Installation calls post-rooting using `pm install`
- Installation disguised as a system app
- Automatic installation using Unknown Sources policy
- Automated user approval scripts

These methods have been repeatedly blocked with changes in Android security policies and are not sustainable from a long-term operational perspective.

---

### 4.5 Relationship Between Android Version and Silent Install

Silent Install is not a feature dependent on a specific Android version but is contingent on the following factors:

- Management model (whether the device is a Device Owner)
- Support for Android Enterprise
- Usability of GMS and Managed Google Play

The notion that Silent Install was restricted due to an increase in Android version is incorrect. Rather, it was the **unofficial installation pathways** that were blocked.

If the official Enterprise pathway is used,  
stability increases with newer Android versions.

---

### 4.6 Scope of Silent Install

In this document, Silent Install encompasses the following tasks:

- Initial application installation
- Application updates
- Application reinstallation
- Remote application removal and replacement

However, permission requests or user input requirements within the application  
are not included in the scope of Silent Install.

---

### 4.7 Summary of Silent Install Definition in This Document

The definition of Silent Install used in this document is as follows:

> Silent Install is  
> **the method of installing or updating applications without user intervention,  
> performed through an official pathway by MDM policy,  
> within an Android Enterprise-based Device Owner environment**.

---

## 5. Relationship Between Device Owner and Silent Install

This section explains the technical meaning of Device Owner privileges and analyzes the structural reasons that enable Silent Install through such privileges.

---

### 5.1 Conceptual Position of Device Owner

Device Owner represents **the highest level of management authority** in the Android management model, declaring that the device is **corporate-owned (Corporate-Owned)** at the OS level.

A device set as Device Owner operates under the following premises:

- Ultimate control over the device does not reside with the user.
- The operating system prioritizes the management entity's policies.
- **Management consistency and adherence to security policies** take precedence over user experience.

Silent Install is structurally permitted under these premises.

---

### 5.2 Scope of Device Owner Privileges

With Device Owner privileges granted, the management entity can perform the following:

- Install and update applications without user approval
- Automatically grant application permissions
- Enforce system settings, network, and security policies
- Restrict access to the home screen, status bar, and settings apps
- Enforce and maintain Kiosk mode

Among these, the **ability to install applications without user approval** forms the core foundation for Silent Install.

---

### 5.3 Reasons for Silent Install Being Dependent on Device Owner

Silent Install is not merely a difference in installation method but signifies **the transfer of installation authority from the user to the management entity**.

Android adheres to the following principles:

- On user-owned devices, apps cannot be installed without user approval.
- On organization-owned devices, apps can be installed according to management policies.

The criterion distinguishing these two principles is whether the **Device Owner setting is configured**.

Thus, Silent Install occurs not because of a specific API call or a special feature of an Android version but as a result of the **management state called Device Owner**.

---

### 5.4 Integration of Device Owner and Managed Google Play

Device Owner privileges alone do not perform Silent Install. The actual installation involves the following components:

- Device registered as Device Owner
- Android Enterprise management environment
- Managed Google Play
- MDM's app deployment policy (Required App)

In this structure, Device Owner provides the **basis for the authority to execute installation commands**, and Managed Google Play acts as the **trusted app supply path**.

---

### 5.5 Methods and Limitations in Acquiring Device Owner

Device Owner can only be set when the device is in a factory-reset state. The primary methods of acquisition include:

- Zero-touch Enrollment
- QR code registration during initial setup
- Pre-registration via OEM/reseller

A device already set up for personal use cannot be converted to Device Owner without a reset.

This restriction is a necessary condition to maintain consistency in the security model.

---

### 5.6 Clear Distinction from Profile Owner

In addition to Device Owner, Android also supports the Profile Owner model. However, Profile Owner has the following limitations:

- Manages only the work profile area, not the entire device
- Unable to control user areas
- Inappropriate for Silent Install

Therefore, this document does not consider Profile Owner as an alternative for Silent Install.

---

### 5.7 Summary of the Relationship Between Device Owner and Silent Install

The relationship between Device Owner and Silent Install can be summarized as follows:

- Device Owner is a **necessary prerequisite** for Silent Install.
- Without Device Owner, Silent Install does not occur.
- Silent Install is a **normal and official operation** based on Device Owner privileges.

In short, the feasibility of Silent Install is determined by **which management model the device is part of**, not by technical tricks or Android versions.

---

## 6. Android Version Changes and Silent Install Policy

This section outlines the flow of security policy changes with Android OS version upgrades and analyzes how these changes have impacted Silent Install policy. It also technically explains why Silent Install was perceived as unstable or impossible in the past.

---

### 6.1 Basic Direction of Android Security Policy Changes

Since its inception, Android has continuously pursued the strengthening of security, with the following principle being consistently reinforced as versions have progressed:

- Blocking actions without user consent
- Limiting background operations
- Strengthening the separation between system and application areas
- Removing indirect permission elevation paths

These changes are policies aimed at protecting **general user environments** and are not intended to negate or limit organizational management environments.

---

### 6.2 Before Android 5.x: A Period When Bypass-Based Installation Was Possible

In versions prior to Android 5.x, the following methods were relatively easy to use:

- Installation using system app privileges
- Utilization of signature permissions
- Unattended installations via ADB
- Rooting followed by `pm install` calls

During this period, operations similar to Silent Install were feasible, but these were **not based on official management models** and were structurally unsustainable due to strengthening security policies.

---

### 6.3 Android 6.x: Introduction of Runtime Permissions and a Turning Point