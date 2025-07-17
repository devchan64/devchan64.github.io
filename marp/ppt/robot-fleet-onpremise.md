---
marp: true
paginate: true
---

# 온프레미스 로봇 운영 플랫폼 설계 사례

> 실시간 메시징, 분산 클러스터, 자동화 배포 흐름의 온프레미스 적용 사례

---

## 프로젝트 개요 및 문제 정의

- 보안구역 내 제한된 네트워크 환경
- ROS 기반 자율주행 로봇 6대 운영
- 고빈도 센서 데이터 및 카메라 스트림 중계
- 현장 UI 및 관제 UI 이중 연동 필요
- 자동화 배포와 원격 유지보수 요구

> ※ 영상 스트림은 설계에 포함되었으나 운영 배포에서는 제외됨

---

## 운영 환경 제약 사항

- 인터넷이 차단된 독립 네트워크
- AWS IoT 기반 MQTT만 제한적으로 허용
- 클라우드 직접 호출 불가
- 운영 대상: ROS 기반 로봇 6대

---

## 아키텍처 구성

<div class="mermaid">
  graph LR
  subgraph RB1[Robot1]
    ROS[ROS Node]
    AGENT[Agent - YAML & Binary]
    SVC[ROS Update Handler]
    KUBE[Kubeless Function]
    NATS1[NATS - Robot1]
  end
  RB2[Robot2,...] --> NATS2
  subgraph NATS[NATS Cluster]
    NATS1 <--> NATS2[NATS - Robot2,...] <--> NATS_MAIN[NATS - 관제 서버]
  end
  ROS --> AGENT --> NATS1
  AGENT --> MQTT[AWS IoT MQTT]
  NATS --> WS[WebSocket Agent] --> UI[Touch UI / WebView]
  MQTT --> SVC --> KUBE
  S3[S3 패키지 다운로드 및 실행] --> SVC
</div>

---

## 메시징 처리 구조

- NATS 브로커를 로봇별 내장 → 클러스터 구성
- ROS 메시지 → YAML → 바이너리 직렬화 후 송신
- 100MB/s 이상 고빈도 메시지 처리 가능
- 영상 프레임 메시지 설계 포함 (운영 제외)

---

## UI 연동 구조

- 각 로봇: 리눅스 기반 터치모니터 + WebView UI
- WebSocket Agent로 NATS 메시지 실시간 반영
- 관제 서버 UI에서도 동일 메시지 시각화
- 동일 메시지 구조 기반의 UI 이중화 구성

---

## 자동화 배포 흐름

- AWS IoT MQTT 수신 후 ROS Service 트리거
- ROS → Kubeless → S3 패키지 다운로드 실행
- Lambda 아키텍처를 온프레미스에 이식한 형태
- 주요 앱은 수동 롤백 전략으로 유지

---

## 장애 감지 및 유지보수

- 상태머신 기반 장애 조건 탐지
- MQTT 경보, 로그 기반 사후 분석
- 일부 Prometheus 지표 수집, Grafana 시각화
- 터널링 서버 통한 원격 운영자 접속 지원

---

## 기술 선택 및 판단 근거

| 항목 | 선택/전환 | 사유 |
|------|------------|------|
| Kafka → NATS | ✅ | Python 기반 경량 처리, 프레임 메시지 성능 확인 |
| Lambda → Kubeless | ✅ | 클라우드 구조를 온프레미스에 이식 |
| Prometheus | ⚪ | 실험적 시각화 용도로 제한 적용 |
| 영상 스트림 | ❌ | 폐쇄망 리소스 제약으로 미배포 |

---

## 설계 인사이트 요약

1. 실시간성과 구조 안정성의 균형
2. 자동화와 수동 운용 병행 전략
3. 기술 의도와 제약 사이의 타협 설계

> 구조를 설계하고, 실험하고, 운영에 맞게 조정한 **실천 중심 아키텍처 사례**
