---
date: 2024-10-31
layout: post
permalink: /en/2024/10/31/mono-repo-aws-infra-design-guidelines.html
tags:
- Project
- Design Philosophy
title: Design Principles for AWS Infrastructure Based on Monorepo
---
> `gpt-4-turbo` has translated this article into English.
---

> Container-Centric Infrastructure Design Philosophy for Removable Structures

---

## 1. Why a Monorepo?

- For early-stage startups, **speed** is survival.
- An integrated tech stack facilitates fast onboarding and maintenance.
- A **unified development environment** that can manage front-end, back-end, and infrastructure all at once is necessary.
- It's better understood as a **modular monorepo** rather than monolithic.

---

## 2. What is a Removable Structure?

- Refactoring is inevitable during growth.
- Creating a structure where **deletion is easier than addition** ultimately benefits scalability.
- Container-based orchestration structures facilitate *service separation and removal*.

---

## 3. AWS Infrastructure Design Principles

**Container-Based Orchestration**

- Service structure based on ECS + Fargate
- Load Balancer → Target Group → ECS Task → Service

**Network Layer Design**

- Design VPC, Subnet, Route Table, Security Group, etc., considering **separability per service**
- Establish fundamentals like public/private subnet separation, IGW configuration

**Loosely Coupled Authentication and Data Layers**

- Ensure domain independence by separating Cognito, S3, DynamoDB, IoT Core into different packages
- Weak linkage with ECS App facilitates refactoring and scalability

---

## 4. Considerations for Transitioning to MSA

- **Service separation** possible at the ECS Task level
- API Gateway, CloudFront, Route 53 for **service-level traffic distribution**
- Possible introduction of App Mesh, Service Discovery if necessary
- Separation of the data layer (splitting DynamoDB tables, database permission separation, etc.)

---

## 5. Philosophy Summary

- Structures last longer than functions.
- A removable structure **maintains the team's rhythm**.
- Design reflects more of **leadership's direction and standards** than code.

---

## (Appendix) Complete Infrastructure Diagram

> Below is a visual structure of AWS infrastructure configured according to the design philosophy.
> 

```d2
direction: down

Infra: {
  label: "AWS Infrastructure"

  INET: "Internet"

  Traffic: {
    label: "Traffic Management"
    Route53: "Route 53"
  }

  CDN: {
    label: "CDN"
    CloudFront: "CloudFront"
  }

  API: {
    label: "API Gateway"
    APIGateway: "API Gateway"
  }

  NetworkLayer: {
    label: "Network Layer"

    VPC: {
      label: "VPC Network"

      IGW: "Internet Gateway"
      RouteTable: "Route Table"
      SecurityGroup: "Security Group"

      IGW -> RouteTable
      RouteTable -> SecurityGroup

      Subnets: {
        label: "Subnets"
        Subnet1: "Subnet 1"
        Subnet2: "Subnet 2"
        Subnet3: "Subnet 3"
      }

      LoadBalancers: {
        label: "Load Balancers"

        LB1: {
          label: "Load Balancer 1"
          Listener1: "ELB Listener 1"
          TargetGroup1: "Target Group 1"
          Listener1 -> TargetGroup1
        }

        LB2: {
          label: "Load Balancer 2"
          Listener2: "ELB Listener 2"
          TargetGroup2: "Target Group 2"
          Listener2 -> TargetGroup2
        }

        LB3: {
          label: "Load Balancer 3"
          Listener3: "ELB Listener 3"
          TargetGroup3: "Target Group 3"
          Listener3 -> TargetGroup3
        }
      }

      SecurityGroup -> Subnets
      LoadBalancers.LB1.TargetGroup1 -> Subnets.Subnet1
      LoadBalancers.LB2.TargetGroup2 -> Subnets.Subnet2
      LoadBalancers.LB3.TargetGroup3 -> Subnets.Subnet3
    }
  }

  Application: {
    label: "Application Layer"

    ECS: {
      label: "ECS Cluster"

      SRV1: {
        label: "ECS Service 1"
        Task1: "ECS Task 1"
        Frontend: "Frontend"
        Task1 -> Frontend
      }

      SRV2: {
        label: "ECS Service 2"
        Task2: "ECS Task 2"
        API: "API Service"
        Task2 -> API
      }

      SRV3: {
        label: "ECS Service 3"
        Task3: "ECS Task 3"
        Data: "Data Service"
        Task3 -> Data
      }
    }
  }

  # Subnet -> ECS Task connection
  NetworkLayer.VPC.Subnets.Subnet1 -> Application.ECS.SRV1.Task1
  NetworkLayer.VPC.Subnets.Subnet2 -> Application.ECS.SRV2.Task2
  NetworkLayer.VPC.Subnets.Subnet3 -> Application.ECS.SRV3.Task3

  DATA: {
    label: "Data Platform"

    IoT: {
      IoTCore: "IoT Core"
      IoTRules: "IoT Rules"
      IoTCore -> IoTRules
    }

    CW: "Cloud Watch"
    IoT.IoTRules -> CW

    Storage: {
      S3: "S3 Bucket"
      DynamoDB
    }
  }

  AUTH: {
    label: "Authentication"
    CognitoUserPool: "Cognito User Pool"
    CognitoIdentityPool: "Cognito Identity Pool"
  }

  # Major integration relationships
  Application -> DATA
  Application -> AUTH

  INET -> Traffic.Route53 -> CDN.CloudFront -> API.APIGateway -> NetworkLayer.VPC.LoadBalancers
  INET -> NetworkLayer.VPC.IGW
}
```