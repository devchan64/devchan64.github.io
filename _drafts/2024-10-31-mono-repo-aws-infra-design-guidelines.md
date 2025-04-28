---
layout: post
title: "모노레포 기반 AWS 인프라 설계 기준"
date: 2024-10-31
tags: [프로젝트, 설계철학]
---

> 삭제 준비(Expiry-Ready)된 구조를 위한 컨테이너 중심의 인프라 설계 철학입니다.

---

## 1. 왜 모노레포인가?

- 초기 스타트업에게 **속도는 생존**입니다.
- 통합된 기술 스택은 빠른 온보딩과 유지에 유리합니다.
- 프론트엔드, 백엔드, 인프라를 한 번에 관리할 수 있는 **통합 개발 환경**이 필요합니다.
- **모놀리식** 구조보다는 **모듈화된 모노레포**로 이해하는 것이 적합합니다.

---

## 2. 삭제 준비(Expiry-Ready)된 구조란?

- 성장 과정에서는 반드시 **리팩토링**이 수반됩니다.
- **추가보다 삭제가 쉬운 구조**가 확장에 유리합니다.
- 컨테이너 기반 오케스트레이션은 *서비스 단위 분리 및 제거*에 유리한 설계 방식입니다.

---

## 3. AWS 인프라 설계 원칙

### **컨테이너 기반 오케스트레이션**

- ECS + Fargate 기반의 서비스 구조를 채택합니다.
- Load Balancer → Target Group → ECS Task → Service 순으로 구성합니다.

### **네트워크 계층 설계**

- VPC, Subnet, Route Table, Security Group 등은 **서비스별 분리 가능성**을 고려해 설계합니다.
- 퍼블릭/프라이빗 서브넷 분리, IGW 구성 등 **기본기를 정립**합니다.

### **인증과 데이터 계층은 느슨하게 연결합니다**

- Cognito, S3, DynamoDB, IoT Core 등은 별도 패키지로 나누어 **도메인 독립성**을 확보합니다.
- ECS App과 약한 연결 구조를 유지하여 리팩토링 및 확장에 유리하게 구성합니다.

---

## 4. MSA 전환 시 고려할 점

- ECS Task 단위로 **서비스 분리**가 가능합니다.
- API Gateway, CloudFront, Route 53을 통해 **서비스 단위 트래픽 분산**이 가능합니다.
- 필요 시 App Mesh나 Service Discovery 도입을 검토할 수 있습니다.
- 데이터 계층은 DynamoDB 테이블 분리, DB 권한 분리 등을 통해 **독립성을 확보**합니다.

---

## 5. 철학 요약

- 구조는 기능보다 오래갑니다.
- 삭제 준비(Expiry-Ready)된 구조는 **팀의 리듬을 유지하게 만듭니다.**
- 설계는 코드보다 **리더십의 방향성과 기준**을 더 많이 반영합니다.

---

## (부록) 전체 인프라 구조도

> 아래는 위 설계 철학에 따라 구성된 AWS 인프라의 시각적 구조입니다.

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

  # Subnet -> ECS Task 연결
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

  # 주요 연동 관계
  Application -> DATA
  Application -> AUTH

  INET -> Traffic.Route53 -> CDN.CloudFront -> API.APIGateway -> NetworkLayer.VPC.LoadBalancers
  INET -> NetworkLayer.VPC.IGW
}
```
