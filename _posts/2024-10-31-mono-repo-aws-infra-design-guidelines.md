---
layout: post
title: "모노레포 기반 AWS 인프라 설계 기준"
date: 2024-10-31
tags: [프로젝트, 설계철학]
---

> 삭제 가능한 구조를 위한 컨테이너 중심의 인프라 설계 철학

---

## 1. 왜 모노레포인가?

- 초기 스타트업은 **속도**가 생존이다.
- 통합된 기술 스택은 빠른 온보딩과 유지에 유리하다.
- 프론트/백/인프라까지 한 번에 관리 가능한 **통합 개발 환경**이 필요하다.
- **모놀리식**이라기보다는 **모듈화된 모노레포**로 이해하는 것이 적합하다.

---

## 2. 삭제 가능한 구조란?

- 성장 과정에서는 반드시 **리팩토링**이 수반된다.
- *“추가보다 삭제가 쉬운 구조”**를 만드는 것이 궁극적으로 확장에 유리하다.
- 컨테이너 기반 오케스트레이션 구조는 *서비스 단위 분리 및 제거*에 유리하다.

---

## 3. AWS 인프라 설계 원칙

**컨테이너 기반 오케스트레이션**

- ECS + Fargate 기반 서비스 구조
- Load Balancer → Target Group → ECS Task → Service

**네트워크 계층 설계**

- VPC, Subnet, Route Table, Security Group 등은 **서비스 별 분리 가능성**을 고려해 설계
- 퍼블릭/프라이빗 서브넷 분리, IGW 구성 등 **기본기 정립**

**인증과 데이터 계층은 느슨하게 연결**

- Cognito, S3, DynamoDB, IoT Core 등은 별도 패키지로 나누어 **도메인 독립성 확보**
- ECS App과 약한 연결로 리팩토링/확장에 유리한 구조

---

## 4. MSA 전환 시 고려할 것

- ECS Task 단위로 **서비스 분리** 가능
- API Gateway, CloudFront, Route 53으로 **서비스 단위 트래픽 분산**
- 필요 시 App Mesh, Service Discovery 도입 가능
- 데이터 계층 분리(DynamoDB 테이블 분할, DB 권한 분리 등)

---

## 5. 철학 요약

- 구조는 기능보다 오래간다.
- 삭제 가능한 구조는 **팀의 리듬을 유지하게 만든다.**
- 설계는 코드보다 **리더십의 방향성과 기준**을 더 많이 반영한다.

---

## (부록) 전체 인프라 구조도

> 아래는 위 설계 철학에 따라 구성된 AWS 인프라의 시각적 구조이다.
> 

```PlantUML
@startuml
!define RECTANGLE_COLOR #F5F5F5
!define RECTANGLE_BORDER_COLOR #C0C0C0
!define RECTANGLE_TEXT_COLOR #333333

skinparam defaultFontColor RECTANGLE_TEXT_COLOR
skinparam defaultBackgroundColor RECTANGLE_COLOR
skinparam rectangleBorderColor RECTANGLE_BORDER_COLOR
skinparam layoutOrientation topToBottom

skinparam nodesep 50
skinparam ranksep 30
skinparam ArrowSpacing 1.5
skinparam Padding 10
skinparam Margin 15

rectangle "AWS Infrastructure" as Infra {  

  together{
    rectangle "Internet" as INET

    package "Traffic Management" as TrafficPackage {
      rectangle "Route 53" as Route53
    }

    package "CDN" as CDNPackage {
      rectangle "CloudFront" as CloudFront
    }

    package "ApiGateway" as ApiGateway {
      rectangle "API Gateway" as APIGateway
    }
  }
  
  package "Network Layer" as NetworkLayer {
    package "VPC Network" as NetworkPackage {
      together{
        rectangle "Internet Gateway" as IGW
        rectangle "Route Table" as RouteTable
        rectangle "Security Group" as SecurityGroup      

        IGW --> RouteTable
        RouteTable --> SecurityGroup        
      }

      package "Subnets" as SubnetPackage {
        rectangle "Subnet 1" as PublicSubnet1
        rectangle "Subnet 2" as PublicSubnet2
        rectangle "Subnet 3" as PublicSubnet3
      }

      SecurityGroup --> SubnetPackage

      package "Load Balancers" as LoadBalancers {
        package "Load Balancer 1" as LoadBalancer1 {
          rectangle "ELB Listener 1" as Listener1
          rectangle "Target Group 1" as TargetGroup1
          Listener1 --> TargetGroup1
        }
        package "Load Balancer 2" as LoadBalancer2 {
          rectangle "ELB Listener 2" as Listener2
          rectangle "Target Group 2" as TargetGroup2
          Listener2 --> TargetGroup2
        }
        package "Load Balancer 3" as LoadBalancer3 {
          rectangle "ELB Listener 3" as Listener3
          rectangle "Target Group 3" as TargetGroup3
          Listener3 --> TargetGroup3
        }
      }
    }
  }

  package "Application" as AppPackage {
    package "ECS Cluster" as ECSCluster {
      package "ECS Service 1" as ECSService1 {
        rectangle "ECS Task 1" as Task1
        rectangle "Frontend" as FESrv
        Task1 --> FESrv
      }
      package "ECS Service 2" as ECSService2 {
        rectangle "ECS Task 2" as Task2
        rectangle "API Service" as APISrv
        Task2 --> APISrv
      }
      package "ECS Service 3" as ECSService3 {
        rectangle "ECS Task 3" as Task3
        rectangle "Data Service" as DataSrv
        Task3 --> DataSrv
      }
    }
  }

  together{
    package "Authentication" as AuthPackage {
      rectangle "Cognito User Pool" as CognitoUserPool
      rectangle "Cognito Identity Pool" as CognitoIdentityPool
    }

    package "DataPlatform" as DataPlatformPackage {
      package "Storage" as StoragePackage {
        rectangle "S3 Bucket" as S3
        rectangle "DynamoDB" as Database
      }

      package "IoT" as IoTPackage {
        rectangle "IoT Core" as IoTCore
        rectangle "IoT Rules" as IoTRules
        IoTCore --> IoTRules
      }

      rectangle "Cloud Watch" as CW

      CloudFront --> APIGateway
    }
  }
}

Route53 --> CloudFront
INET --> IGW
INET --> Route53
TargetGroup1 -down-> PublicSubnet1
TargetGroup2 -down-> PublicSubnet2
TargetGroup3 -down-> PublicSubnet3
PublicSubnet1 --> Task1
PublicSubnet2 --> Task2
PublicSubnet3 --> Task3
APIGateway --> LoadBalancers
AppPackage --> DataPlatformPackage
AppPackage --> AuthPackage
IoTRules --> CW

@enduml
```

![image.png](/assets/images/2024-10-41-mono-repo-aws-infra-design-guidelines.png)