---
layout: post
title: "모노레포 기반 AWS 인프라 설계 기준"
tags: [프로젝트, 설계철학]
---

## 1. 왜 모노레포인가?

스타트업의 초기에는 속도가 곧 생존입니다.  
프론트엔드, 백엔드, IaC, 배포 파이프라인이 하나의 흐름 안에서 관리되어야 빠르게 개발하고 수정할 수 있습니다.  

모노레포는 단순한 코드 통합이 아니라, 전체 구조를 일관되게 추적하고 조정할 수 있는 기반을 제공합니다.  
모듈화된 구조를 유지하면서도 통합된 흐름 안에서 관리되기 때문에, 모놀리식의 생산성과 서비스 분리 가능성을 동시에 확보할 수 있습니다.

이러한 통합 환경은 구조의 변경과 제거가 쉬운 상태로 유지되며, 관찰 가능성을 확보하는 데에도 유리합니다.

---

## 2. Expire-Ready, 삭제 준비된 구조란?

모든 시스템은 변화를 전제로 운영됩니다.  
그렇다면 '추가'보다 '삭제'가 쉬운 구조가 되어야 합니다.

리팩토링은 예외가 아니라 전제이며, 구성 요소는 쉽게 교체되거나 제거될 수 있어야 합니다.  
컨테이너 기반 구조는 이런 유연함을 제공합니다.  
각 기능을 독립된 태스크로 분리하고, 필요할 때 쉽게 교체할 수 있습니다.

삭제 준비된 구조는 팀의 속도와 리듬을 유지하게 하고, 전환에 따르는 비용을 줄여줍니다.

---

## 3. AWS 인프라 설계 원칙

### 컨테이너 기반 오케스트레이션

ECS와 Fargate를 기반으로, 앱은 각각 독립된 컨테이너로 실행됩니다.  
서비스는 ALB에서 Target Group을 거쳐 ECS Task로 라우팅되며, 이 경로는 각 구성 요소의 동작을 분리하고 관찰할 수 있게 합니다.

이런 구조는 문제의 위치를 빠르게 파악할 수 있으며, 서비스 단위로 분리하거나 제거하기에도 용이합니다.

### 네트워크 계층 설계

VPC, Subnet, Route Table, Security Group 등은 처음부터 서비스 단위로 나눌 수 있도록 계층화합니다.  
퍼블릭과 프라이빗 서브넷의 분리, IGW 구성은 단순한 기본 설정이 아니라, 이후 서비스 확장이나 분리에 필요한 조건입니다.

나중에 나누려면 처음부터 나누기 쉽게 설계해야 합니다.

### 인증과 데이터 계층은 느슨하게 연결

Cognito, S3, DynamoDB, IoT Core 같은 도메인 컴포넌트는 ECS 앱과 직접 결합하지 않습니다.  
각 컴포넌트는 독립된 패키지로 유지되어, 변경하거나 교체할 때 다른 구성에 영향을 주지 않습니다.

이렇게 느슨하게 연결된 구조는 리팩토링, 재구성, 서비스 분리에 모두 유리하며, 점진적인 MSA 전환을 가능하게 합니다.

---

## 4. MSA 전환 시 고려할 점

처음부터 완전한 MSA를 목표로 하진 않습니다.  
MSA는 구조적 유연성과 관찰 가능성이 확보된 이후 자연스럽게 전환되어야 합니다.

초기에는 ALB와 API Gateway를 배치해 서비스별 트래픽 경로를 명확히 나눕니다.  
이것만으로도 오퍼레이션과 로깅, 장애 추적의 기반을 마련할 수 있습니다.

이후 필요에 따라 App Mesh나 ECS 서비스 디스커버리를 통해 통신 흐름을 정교하게 다듬을 수 있습니다.  
데이터 계층은 DynamoDB 테이블과 IAM 권한을 나눠 기능 독립성과 보안 경계를 유지합니다.

우리는 하나의 단일 구조에서 시작하되, 서비스 단위로 나눌 수 있도록 설계합니다.  
삭제 가능한 단위로 구성된 모놀리식 구조는 점진적이고 안전한 전환을 가능하게 합니다.

---

## 5. 철학 요약

구조는 기능보다 오래갑니다.  
단기적인 기능 구현보다, 장기적인 구조 유지를 위한 판단이 더 중요합니다.

삭제 준비된 구조는 변화와 리팩토링을 가능하게 하고, 팀이 일정한 속도로 나아갈 수 있는 조건이 됩니다.

설계는 단순한 기술의 문제가 아니라, 리더십과 방향성의 표현입니다.  
기능이 아닌 구조로 먼저 말해야 하는 이유입니다.

우리는 처음부터 나누지 않습니다.  
대신 나누기 쉬운 구조로 시작합니다.

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
