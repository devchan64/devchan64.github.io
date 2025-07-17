---
marp: true
paginate: true
---

# 메시지 기반 아키텍처와

## 운영 중심 설계

**2024.11.01 | DevOps 사례 공유**

---

## 문제 상황과 선택의 갈림길

Monolith + REST API 구조의 특징:
- 연결은 쉽지만, 복원은 어렵다
- 모든 것이 서로 엮여 있어 변경이 부담된다
- 장애는 전체 서비스로 확산된다
- 운영자는 어디서 문제인지 추적하기 어렵다

---

## 메시지 기반 구조의 선택 배경

- 실시간성보다 무결성이 중요한 비즈니스
- 느슨한 결합 → 장애 격리
- 운영자 추적성 향상

💡 APM, Grafana 연동이 쉬워 운영 대응 속도 개선

---

## 설계 전략과 기술적 기반

- ROS 경험: 메시지 중심 설계에 익숙
- `Publisher-Subscriber` 구조 → 분산과 복원력 강조
- 설계 초기부터 운영 지표를 고려한 DevOps 시각

🛠 운영과 개발을 통합적으로 고려한 설계

---

## 팀 내 수용 전략

- 복잡하다는 인식 → 구체적 시나리오로 설득
- 설계 이점:
  - 운영 비용 절감 (Kinesis 등 관리형 서비스)
  - 문제 추적 용이 (trace ID, message list)
  - 수평 확장 가능 (컨슈머 단위 확장)

---

## 네임스페이스 구조

- `device.`, `service_platform.`, `data_platform.`, `3rd_party.`
- 기능 분리 + 언어 정렬 통한 협업 기준 정립

🎯 구조 해석의 명확성과 커뮤니케이션 효율성 향상

---

## 아키텍처 도식

<div class="mermaid">
graph LR
%% --- 상위 서비스 구조 ---
subgraph SRV [Service]
DEV[Device]
DEV1[Device] --> AGENT[Agent]
APP[App] --> ALB 
end    
subgraph 3RD [External Service]
3RD_DEV[Ext. Device] --> 3RD_CLOUD[Ext. Cloud] --> BRIDGE[C2C Bridge]
end
%% --- 메인 서비스 플랫폼 ---
subgraph SP [Service Platform]
AUTH[Auth] --> API[API Gateway]
X509[X.509] --> MSG[Message Broker]
BRIDGE --> MSG
API --> MSG
MSG --> RULE[Rule Engine] --> DT[Device Tween] --> MSG
subgraph OC [Container]
MSA[Worker A]
MSA1[Worker B]
MSA2[Worker C]
end
API --> MSA
RULE --> MSA1
RULE --> MSA2 --> MSG
end
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
ALB --> AUTH
</div>

🧩 계층 간 메시지 흐름으로 구성 요소 유기적 연결

---

## 메시지와 데이터 흐름

- MQTT + Kinesis → 이벤트 기반 비동기 처리
- `data_platform`: 수집 → ETL → 분석
- 도메인별 계층 분리로 변경 용이성 강화

---

## 운영 성과

✅ 실시간 모니터링  
✅ 장애 격리 및 빠른 복원  
✅ 운영자와 개발자의 협업 강화

> 장애 분석 시간: **수 시간 → 수 분**

---

## 설계 철학

- 메시지는 통신이 아닌 구조
- 네임스페이스는 언어 정렬 도구
- 아키텍처는 조직 구조와 연결되어야 함

> 설계자는 기술과 협업의 중재자

---

## 핵심 메시지

> "좋은 메시지 설계는 결국 좋은 운영 설계입니다."

> "복잡한 연결에 의한 시스템 구성은 메시지로 단순해집니다."
