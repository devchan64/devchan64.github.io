---
marp: true
paginate: true
---

# 메시지 기반 아키텍처 전환

## 운영을 위한 구조 설계 경험

**2025.07.17**

---

## 프로젝트 개요

- **목표**: 엣지 시스템 포함 전체 서비스의 운영 복원력 개선
- **배경**: REST 기반 구조에서 반복되는 장애 확산과 추적 불가
- **역할**: 구조 분석, 아키텍처 재설계, 운영 지표 정의, 기술 설득

> 기술뿐 아니라 **운영과 협업**까지 포함한 구조적 전환 경험

---

## 현장에서 실제 겪은 문제

- 장비는 작동 중인데 앱은 응답 없음  
- 운영자: "서버 문제인가요?"  
- 개발자: "엣지 문제 같은데요?"  
- 로그는 분산되어 있고, 어디부터 봐야 할지 불분명

> 기능이 아니라 흐름이 보이지 않는 구조가 문제였습니다

---

## 기존 구조 시각화

<div class="mermaid">
flowchart LR
    subgraph Site
      Device1 --> Edge
      Device2 --> Edge
    end
Edge --> REST[REST-API-Service]
REST --> RDS
</div>

---

## 문제 요약 (1/2)

### 구조와 배포의 제약

- **모놀리스 서비스**  
  기능이 단일 흐름으로 묶여 장애가 전체로 확산

- **동일한 엣지 구성**  
  모든 사이트에 같은 엣지를 배포해야 했고  
  네트워크·센서·운영정책의 차이를 반영할 수 없었음

- **REST API 기반 로그**  
  엣지와 서버 간 연결이 끊기면 상태 기록 자체가 불가

---

## 문제 요약 (2/2)

### 네트워크 현실과 운영 한계

- **방화벽·라우터에 의해 엣지 접근 불가**  
  운영자가 엣지 상태를 직접 확인할 수 없음

- **연결 오류에 대한 복구 부재**  
  요청 실패 시 자동 재시도도, 오류 알림도 없음

- **문제 발생 시 로그 탐색**  
  요청 ID도, 흐름 단서도 없어 시간 역추적에 의존

> 이런 상황에서는 구조적으로 흐름을 다시 설계해야 했습니다

---

## 구조 전환 방향

- 기술의 문제가 아닌 운영 흐름 단절의 문제
- 단일 구조 해체 → 메시지 중심의 유닛화
- 사이트별 조건을 수용할 수 있도록 구조 분화

전환 전략:

- 모놀리스를 쪼개는 것이 아니라 흐름을 분리
- 엣지를 하나로 통일하는 것이 아니라 각기 다른 버전 허용
- 추적성과 복원력을 메시지 자체로 구성

---

## 팀의 우려와 수용 전략

### 기술
- “REST가 익숙한데 왜 바꾸죠?”
- “메시지 구조는 디버깅이 어렵습니다”

### 운영
- “운영자가 메시지를 이해할 수 있을까요?”
- “MQTT는 안정성이 떨어지지 않나요?”

---

## 설득 전략

- 장애 사례를 중심으로 문제를 구체화
- 운영 지표 기반의 복원 흐름을 설명
- Kafka 대신 **Kinesis** 같은 관리형 서비스로 진입장벽 완화
- 메시지 리스트, request_code, trace ID 등 운영 중심 시야 강조

> 기술의 장점보다, 운영이 쉬워진다는 메시지를 반복했습니다

---

## 설계 기반: 메시지 중심 경험

- 로봇 운영체제 **ROS (Robot Operating System)** 경험
- Pub/Sub 구조 기반의 상태 추적과 복원 설계에 익숙
- 구성 요소 간 느슨한 연결 + 유기적 메시지 흐름

> 기술보다 흐름을 설계하는 데 익숙한 경험이 도움이 됐습니다

---

## 메시지 기반 구조의 위험 요소

### 메시지 순서 불일치

→ `request_code`, `timestamp` 등 명시 필요

### 브로커 장애

→ 재처리 전략, 모니터링 지표 필요

### 흐름 추적 어려움

→ `trace ID`, `action_start_time`, 메시지 구조화 필요

> 메시지 구조는 설계 없이는 오히려 혼란을 만듭니다

---

## 운영을 위한 지표 설계

- `action_start_time`, `action_finish_time`: 단계별 지연 추적
- `heartbeat`: 장치/엣지 상태 생존 확인
- `request_code`: 요청의 의도 명시
- `response_code`: 결과 분류 (성공, 실패, 무시 등)

> 지표는 모니터링이 아닌 구조의 일부로 설계했습니다

---

## 네임스페이스 기반 구조

- 기능 중심의 메시지 네이밍 구조:
  - `device.`, `service_platform.`, `data_core.`, `3rd_party.`

- 단순한 폴더 구분이 아니라 기능 해석 언어
- 팀 간 협업 기준을 통일하는 문법적 기반

> 구조를 읽는 언어가 생기자 협업도 쉬워졌습니다

---

## 아키텍처 도식

<div class="mermaid">
graph LR
%% --- 메인 서비스 플랫폼 ---
subgraph SP [Service Platform]
AUTH[Auth] --> API[API Gateway]
API --> MSG
MSG --> RULE[Rule Engine] --> DT[Device Tween] --> MSG
X509[X.509] --> MSG[Message Broker]
subgraph OC [Container]
MSA[Worker A]
MSA1[Worker B]
MSA2[Worker C]
end
API --> MSA
RULE --> MSA1
RULE --> MSA2 --> MSG
end
%% --- 상위 서비스 구조 ---
subgraph SRV [Service]
APP[App]
DEV[Device]
DEV1[Device] --> AGENT[Agent]
end
subgraph 3RD [External Service]
3RD_DEV[Ext. Device] --> 3RD_CLOUD[Ext. Cloud] --> BRIDGE[C2C Bridge]
end
BRIDGE --> MSG
%% --- 데이터 플랫폼 ---
subgraph DP [Data Platform]
DATA_API[Data API] --> MODEL[Data Model]
DATA_BRIDGE[Data Bridge] --> MODEL
ETL[ETL Service] --> MODEL
MODEL --> DATA[Storage]
end
%% --- Cross-domain 연결 ---
MSA --> DATA_API
API --> DATA_API
RULE --> DATA_BRIDGE
DATA_BRIDGE --> ETL
DEV[Device] --> X509
AGENT --> X509
APP --> AUTH
</div>

---

## 구조 전환 전후 비교

| 항목        | 전 (REST 기반)                   | 후 (메시지 기반)                            |
| ----------- | -------------------------------- | ------------------------------------------- |
| 장애 복원   | 없음                             | 메시지 단위 격리, 장애전파 차단 |
| 문제 추적   | 로그 수작업 탐색                 | trace ID + 지표 기반 추적                   |
| 협업 기준   | 직관·감각 의존                   | 네임스페이스 기반 공통 언어                 |
| 운영 유연성 | 엣지 구성 고정                   | 엣지 버전 분화 + 사이트 맞춤 구성 가능      |

---

## 전환 이후의 성과

- 장애 추적 시간: 수 시간 → 수 분  
- 운영자와 개발자 간 문제 인식 공유  
- 실시간 모니터링 가능 (APM, CloudWatch 등)  
- 엣지 구성 다양화로 현장 대응력 증가

> 기술 전환보다 **운영 구조 재설계**가 핵심이었습니다

---

## 설계 철학

- 메시지는 통신이 아니라 **구조**
- 네임스페이스는 협업을 위한 **공통 언어**
- 아키텍처는 기술 이전에 **운영과 조직의 구조**

> 설계란, 기술과 협업을 함께 설계하는 일입니다

---

## 감사합니다
