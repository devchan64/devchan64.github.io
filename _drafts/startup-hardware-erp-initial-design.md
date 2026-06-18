---
layout: post
title: "스타트업을 위한 하드웨어 ERP 초기 설계 기준"
tags: [설계철학, ERP, 스타트업]
---

# 스타트업을 위한 하드웨어 ERP 초기 설계 기준

하드웨어 제품을 만드는 스타트업은 어느 시점부터 개인 문서와 스프레드시트만으로 운영하기 어려워진다.

처음에는 제품명, 모델명, 시리얼 번호, 입고 수량 정도만 관리하면 충분해 보인다.  
하지만 제품 옵션이 늘어나고, BOM이 바뀌고, 부품 Lot을 추적해야 하고, 리콜 대상 Serial을 찾아야 하는 순간부터 문제는 단순한 목록 관리가 아니게 된다.

이때 필요한 것은 거대한 ERP를 한 번에 도입하는 일이 아니다.  
초기 프로젝트를 시작할 때부터 **나중에 PIM, SCM, BOM, FMS, Inventory, 원가분석으로 확장될 수 있는 기준**을 잡아두는 일이다.

이 글은 하드웨어 ERP 초기 설계를 세 가지 관점으로 정리한다.

```text
프로젝트 관점 = 무엇을 1차 범위로 만들 것인가
설계철학 = 어떤 책임과 경계를 절대 섞지 않을 것인가
플랫폼화 기준 = 언제 기능이 아니라 플랫폼으로 확장할 것인가
```

핵심 질문은 단순하다.

> 지금 당장 모든 ERP 기능을 만들 필요는 없다.  
> 하지만 지금 만든 구조가 나중의 ERP 확장을 막아서는 안 된다.

---

# I. 프로젝트 관점: 처음부터 ERP 전체를 만들지 않는다

스타트업의 ERP 프로젝트가 실패하는 흔한 이유는 두 가지다.

첫 번째는 처음부터 너무 크게 시작하는 것이다.  
PIM, SCM, BOM, Inventory, FMS, Costing, Pricing, Quality까지 한 번에 만들려고 하면 프로젝트는 금방 무거워진다.

두 번째는 너무 작게만 보는 것이다.  
당장 필요한 Serial 목록이나 제품 목록만 빠르게 만들면 초기 속도는 나지만, 나중에 생산 추적, 재고, 원가, 품질이 붙을 때 구조를 다시 갈아엎게 된다.

따라서 초기 프로젝트는 **범위는 작게, 경계는 크게** 잡아야 한다.

## 1. 1차 프로젝트의 목적

1차 프로젝트의 목적은 완성형 ERP 구축이 아니다.  
목적은 하드웨어 운영에 필요한 최소 기준정보와 추적 구조를 만드는 것이다.

초기 범위는 다음 네 단계가 적절하다.

| 단계 | 범위 | 목적 |
|---|---|---|
| 1단계 | 제품 기준정보 | 고객에게 제공 가능한 제품 구성을 구조화한다. |
| 2단계 | 제품 구조 | 생산 가능한 물리 구조를 Revision 단위로 관리한다. |
| 3단계 | 생산 추적 | 어떤 부품 Lot이 어떤 생산 Lot과 Serial에 사용되었는지 추적한다. |
| 4단계 | 품질 추적 | 문제가 생겼을 때 영향 범위를 빠르게 확인하고 조치한다. |

이 네 단계까지만 제대로 만들어도 운영 수준은 크게 달라진다.  
반대로 이 네 단계가 없으면 재고, 공정, 원가, 가격을 붙여도 기준이 흔들린다.

## 2. 1차 릴리즈 범위

1차 릴리즈는 다음 데이터까지를 기준으로 삼는다.

### 제품 기준정보

- Product
- Product Model
- Option Group
- Option Value
- Configuration Rule
- Configuration / Variant

목표는 고객에게 제공 가능한 제품 구성을 시스템이 판단할 수 있게 만드는 것이다.

### 제품 구조

- Part
- Assembly
- BOM
- BOM Line
- BOM Revision

목표는 생산 가능한 물리 구조를 변경 이력과 함께 관리하는 것이다.

### 생산 추적

- Production Order
- Production Lot
- Part Lot
- Serial
- Trace Link

목표는 어떤 실물이 어떤 기준정보와 생산 조건으로 만들어졌는지 추적하는 것이다.

### 품질 추적

- Quality Hold
- Recall Target
- Part Lot 기준 역추적
- Serial 영향 범위 리포트

목표는 품질 이슈가 발생했을 때 영향을 받는 Lot과 Serial을 찾는 것이다.

## 3. 1차에서 제외하되 연결점은 남길 것

초기 프로젝트에서 모든 기능을 만들 필요는 없다.  
하지만 나중에 붙을 수 있는 연결점은 남겨야 한다.

| 추후 확장 영역 | 1차에서 남겨야 할 연결점 |
|---|---|
| Inventory | Production Order, Production Lot, Part Lot에 재고 예약과 수불 연결 가능성 |
| FMS / MES | Production Order, Production Lot에 Route, Operation, 작업 실적 연결 가능성 |
| Costing | BOM Revision, BOM Line, Production Lot에 원가 버전과 원가 스냅샷 연결 가능성 |
| Pricing | Configuration / Variant에 가격표와 판매단가 연결 가능성 |
| SCM | Part, Part Lot, Production Order에 구매·입고·공급처 연결 가능성 |

이것이 초기 프로젝트의 현실적인 균형이다.

기능은 만들지 않아도 된다.  
하지만 데이터가 나중의 기능을 거부하면 안 된다.

## 4. 메뉴도 프로젝트 범위에 맞춰 나눈다

메뉴 구조는 단순한 화면 분류가 아니다.  
조직이 데이터를 어떤 책임으로 바라볼지를 결정한다.

초기 메뉴는 다음 정도로 충분하다.

```text
운영 > 생산관리

├─ 생산 현황
├─ 제품 기준정보
├─ 제품 구조 관리
├─ 생산 준비
├─ 생산 실행
├─ 생산 추적
└─ 품질 관리

추후 확장
├─ 원가·단가 관리
├─ 인벤토리 관리
└─ 생산 공정 관리
```

제품 기준정보와 생산 이력을 같은 메뉴에 섞으면 권한, 변경 승인, 품질 추적이 모호해진다.  
메뉴는 사용자의 편의를 위한 분류이기도 하지만, 동시에 데이터 책임을 드러내는 구조여야 한다.

메뉴별 책임은 다음처럼 분리한다.

| 메뉴 | 주 사용자 | 책임 |
|---|---|---|
| 생산 현황 | 생산 관리자, 품질 관리자 | Production Lot, Serial, 품질 보류 상태를 한 화면에서 확인한다. |
| 제품 기준정보 | 제품 관리자 | Product, Model, Option, Configuration Rule을 관리한다. |
| 제품 구조 관리 | 설계 관리자, 생산기술 담당자 | Part, Assembly, BOM, BOM Revision을 관리한다. |
| 생산 준비 | 생산 관리자 | Released 상태의 모델 구성과 BOM으로 Production Order와 Production Lot을 생성한다. |
| 생산 실행 | 생산 담당자 | Production Lot에 사용 부품 Lot을 연결하고 Serial을 발행한다. |
| 생산 추적 | 생산 관리자, 품질 관리자 | Serial 기준 정방향 추적과 Part Lot 기준 역추적을 수행한다. |
| 품질 관리 | 품질 관리자 | Lot/Serial 보류, 리콜 대상 지정, 영향 범위 확인을 수행한다. |
| CSV 출력 | 각 메뉴 사용자, 운영 조회자 | 현재 권한과 조회 조건에 맞는 목록과 리포트를 반출한다. |

## 5. 핵심 유스케이스로 프로젝트를 검증한다

초기 설계가 맞는지는 엔티티 목록보다 유스케이스로 검증해야 한다.  
다음 흐름이 자연스럽게 이어지면 1차 구조는 어느 정도 올바른 방향에 있다.

### 제품 모델과 옵션 정의

```text
제품 생성
→ 모델 생성
→ 옵션 그룹 생성
→ 옵션 값 생성
→ 옵션 조합 규칙 등록
→ RELEASED 처리
```

이 흐름은 PIM의 최소 기능이다.  
옵션은 자유 텍스트가 아니라 기준정보로 관리되어야 하며, 판매·생산 가능한 Configuration으로 확정될 수 있어야 한다.

### BOM Revision 발행

```text
Part 등록
→ Assembly 등록
→ BOM 생성
→ BOM Line에 Part/Assembly와 수량 등록
→ BOM Revision 검토
→ RELEASED 처리
```

이 흐름은 Product Structure의 최소 기능이다.  
BOM 전체를 하나의 큰 문서처럼 저장하지 않고, Revision과 Line을 분리해야 변경 이력과 원가 롤업이 가능해진다.

### 생산 Lot 생성

```text
Production Order 생성
→ Production Lot 생성
→ Model / Configuration / BOM Revision 선택
→ 생산 수량 입력
→ 사용 Part Lot 등록
→ 생산 완료 후 Serial 발행
```

Production Lot은 생성 시점의 제품 정의를 스냅샷으로 보존해야 한다.  
이 스냅샷이 있어야 기준정보가 바뀌어도 과거 생산 이력이 흔들리지 않는다.

### 품질 역추적

```text
문제 Part Lot 입력
→ 해당 Part Lot이 사용된 Production Lot 조회
→ 영향받은 Serial 목록 조회
→ 출고·등록·설치 상태 확인
→ 품질 보류 또는 리콜 대상으로 전환
```

이 흐름이 빠르게 되지 않으면 생산 추적 시스템의 핵심 목적을 달성하지 못한 것이다.

---

# II. 설계철학: 기준정보와 실물 이력을 섞지 않는다

하드웨어 ERP 설계의 핵심은 데이터 경계다.  
좋은 설계는 많은 기능을 가진 설계가 아니라, 어떤 데이터가 어떤 책임을 갖는지 흔들리지 않는 설계다.

가장 먼저 분리해야 할 것은 다음 세 가지다.

```text
제품/모델/옵션 = 고객·영업·제품기획 관점의 제품 구성 정의
Part/Assembly/BOM/Revision = 설계·구매·생산 관점의 제품 구조 정의
Lot/Serial = 실제 생산·입고·출고된 실물 추적 단위
```

이 경계를 섞으면 나중에 모든 기능이 꼬인다.  
모델명이 바뀌었을 뿐인데 과거 생산 이력이 바뀌고, 옵션명이 바뀌었을 뿐인데 출고된 장비의 스펙이 달라져 보이고, BOM이 수정되었을 뿐인데 이미 생산된 Lot의 구성품이 바뀐 것처럼 보인다.

ERP 설계에서 중요한 것은 데이터를 많이 저장하는 것이 아니다.  
무엇이 기준정보이고, 무엇이 실물 이력인지 구분하는 것이다.

## 1. Product와 Serial은 같은 개념이 아니다

스타트업은 보통 Serial 관리부터 시작한다.  
제품이 생산되면 시리얼을 발행하고, 출고·설치·등록 같은 수명주기 상태와 연결한다.

이 자체는 자연스러운 출발점이다.  
문제는 Serial Registry를 제품 기준정보의 원본처럼 사용하기 시작할 때 발생한다.

Serial은 개별 실물 장비의 식별자다.  
Product, Model, Option, Configuration은 제품 정의의 기준정보다.

```text
제품 기준정보
  └─ Production Order
      └─ Production Lot
          └─ Serial
```

Serial에는 제품 정의를 직접 풀어 쓰기보다, 기준정보를 참조하는 ID와 생산 당시 스냅샷을 함께 저장하는 것이 좋다.

| 필드 | 의미 |
|---|---|
| `productId` | 제품군 또는 제품 마스터 참조 |
| `modelId` | 고객에게 제공된 모델 참조 |
| `configurationId` | 옵션 선택이 확정된 구성 결과 참조 |
| `optionValueIds` | 선택된 옵션 값 ID 목록 |
| `bomRevisionId` | 생산 당시 적용한 BOM 버전 |
| `productionOrderId` | 어떤 생산 지시에서 생성됐는지 |
| `productionLotId` | 같은 조건으로 생산된 묶음 |
| `pimSnapshot` | 출고 또는 등록 시점의 제품명, 모델명, 옵션 표시명 |
| `pimSnapshotVersion` | 스냅샷 구조 변경에 대응하기 위한 버전 |
| `pimMappedAt` | 기준정보 매핑 시각 |
| `pimMappedBy` | 기준정보 매핑자 |

여기서 중요한 원칙은 두 가지다.

첫째, `modelId`, `configurationId`, `optionValueIds`는 PIM의 식별자다.  
표시명과 설명은 PIM에서 조회하거나 스냅샷으로 보관한다.

둘째, `pimSnapshot`은 조회 성능과 이력 보존을 위한 읽기용 데이터다.  
기준정보가 바뀌었다고 과거 Serial의 스냅샷을 자동으로 바꾸면 안 된다.

이미 출고된 장비는 당시의 제품 정의를 기준으로 감사되어야 한다.  
현재의 제품명으로 과거 실물을 덮어쓰면 운영 이력의 신뢰성이 깨진다.

추가로 다음 원칙을 지켜야 한다.

- 옵션은 자유 텍스트로 저장하지 않고 `optionValueIds` 같은 기준정보 식별자로 연결한다.
- 화면 표시가 필요하면 PIM 조회 결과 또는 `pimSnapshot`의 표시명을 사용한다.
- 현재 펌웨어, 하드웨어 버전, 배포 단계 같은 런타임 상태는 PIM 옵션이 아니다.
- BOM Revision은 생산 당시 구조 추적을 위한 필드이며, 고객 표시용 모델/옵션을 대체하지 않는다.
- 등록 해제나 외부 운영 리소스 삭제가 발생해도 PIM 매핑 이력은 삭제하지 않는다.
- Serial 생성 시점에 모델이 확정되지 않을 수 있다면 PIM 필드는 비워둘 수 있지만, 출고·등록·보증 시작 전에는 확정해야 한다.

## 2. PIM은 판매 가능한 구성을 정의한다

PIM(Product Information Management)은 제품 정보를 관리하는 영역이다.  
초기에는 대형 PIM 시스템이 필요하지 않다. 다만 다음 개념은 분리해두어야 한다.

| 개념 | 설명 |
|---|---|
| Product | 제품군 또는 제품 마스터 |
| Product Model | 고객에게 제시되는 판매 모델 |
| Option Group | 선택 가능한 속성의 묶음 |
| Option Value | 옵션 그룹 안에서 선택 가능한 실제 값 |
| Configuration Rule | 허용되거나 금지되는 옵션 조합 규칙 |
| Configuration / Variant | 옵션 선택이 완료된 판매·생산 가능 구성 |

예를 들어 다음과 같은 구조다.

```text
Product: Product Family A
Model: Product Model A

Option Group: Option Category 1
- Option Value 1-A
- Option Value 1-B

Option Group: Option Category 2
- Option Value 2-A
- Option Value 2-B

Configuration:
- Option Value 1-A / Option Value 2-B
- Option Value 1-B / Option Value 2-A
```

PIM의 목적은 화면에 제품명을 예쁘게 보여주는 것이 아니다.  
판매 가능한 제품 구성을 시스템이 판단할 수 있게 만드는 것이다.

## 3. BOM은 제품 구조의 기준이다

PIM이 고객에게 보이는 제품 구성을 정의한다면, BOM은 실제 제품을 무엇으로 만들지 정의한다.

BOM(Bill of Materials)은 완제품을 만들기 위한 Part, Assembly, 수량의 목록이다.  
하드웨어 제품이 복잡해질수록 BOM은 단순 부품 목록이 아니라 변경 이력과 생산 기준의 중심이 된다.

초기에는 다음 개념만 명확히 잡아도 충분하다.

| 개념 | 설명 |
|---|---|
| Part | 구매·재고·품질 관리 대상 부품 |
| Assembly | 여러 Part 또는 하위 Assembly를 조립한 구성품 |
| BOM | 완제품 또는 Assembly의 구성 구조 |
| BOM Line | BOM 안의 한 줄 구성품 |
| BOM Revision | BOM 변경 이력 |
| BOM View | EBOM, MBOM, Service BOM 등 목적별 구조 |

BOM은 반드시 Revision을 가져야 한다.

```text
DRAFT → IN_REVIEW → RELEASED → SUPERSEDED → OBSOLETE
```

이미 생산 Lot에 사용된 BOM Revision은 수정하면 안 된다.  
변경이 필요하면 새 Revision을 발행해야 한다.

아직 검토 중인 BOM으로 생산 오더가 만들어져서도 안 되고, 이미 생산에 사용된 BOM이 조용히 수정되어서도 안 된다.

Version/Revision은 제품 정의 데이터에 붙는다.

```text
Product Model Version
Option Rule Revision
Part Revision
Assembly Revision
BOM Revision
Specification Document Revision
Firmware Version
```

반대로 Lot/Serial은 실물 데이터에 붙는다.

```text
Production Lot
Part Lot
Assembly Lot
Serial
Shipment
Installation
Registration
Quality Hold
```

이 구분은 작아 보이지만 중요하다.  
Revision은 정의의 변경 이력이고, Lot/Serial은 실제 발생한 운영 이력이다.

Production Lot은 반드시 사용한 `modelId`, `configurationId`, `bomRevisionId`를 보존해야 한다.  
Revision 변경은 PLM 성격이므로 승인 상태를 가져야 하고, 생산 사용 이력이 있는 Revision은 직접 수정하지 않는다.

BOM View도 분리해서 생각해야 한다.

- EBOM은 설계 관점의 제품 구조다.
- MBOM은 생산 관점의 제품 구조다.
- Service BOM은 정비와 서비스 관점의 제품 구조다.

생산 Lot에는 원칙적으로 MBOM Revision을 연결한다.  
설계 변경이 생산에 반영되는 시점은 EBOM Revision release가 아니라 MBOM Revision release다.

## 4. SCM과 생산 추적은 Lot에서 시작한다

SCM(Supply Chain Management)을 처음부터 모두 만들 필요는 없다.  
하지만 나중에 구매, 입고, 재고, 생산, 출고로 확장하려면 Lot 개념을 초기에 잡아야 한다.

Lot은 같은 조건으로 생산되거나 입고된 묶음이다.  
Serial은 개별 추적이 필요한 단위다.

```text
Production Order
  └─ Production Lot
      ├─ Consumed Part Lot
      └─ Serial
```

초기 생산 추적에서 관리해야 할 최소 데이터는 다음과 같다.

| 데이터 | 설명 |
|---|---|
| Production Order | 무엇을 몇 대 생산할지 지시하는 작업 단위 |
| Production Lot | 같은 조건으로 생산된 묶음 |
| Part Lot | 같은 조건으로 입고되거나 생산된 부품 묶음 |
| Serial | 개별 장비 식별자 |
| Trace Link | 어떤 Part Lot이 어떤 Production Lot 또는 Serial에 들어갔는지 |
| Quality Status | 정상, 보류, 격리, 리콜 대상 등 품질 상태 |

초기에는 재고 수량 차감까지 만들지 않아도 된다.  
하지만 사용 부품 Lot 추적은 반드시 남기는 것이 좋다.

품질 이슈가 발생하면 시스템은 다음 질문에 답할 수 있어야 한다.

```text
문제 Part Lot
→ 이 Part Lot이 사용된 Production Lot
→ 영향받은 Serial
→ 출고·등록·설치 상태
→ 품질 보류 또는 리콜 대상 전환
```

이 흐름이 가능해야 하드웨어 운영 시스템이라고 부를 수 있다.

## 5. Inventory는 Traceability와 섞으면 안 된다

재고 관리를 시작할 때 흔한 실수는 Trace Link를 재고처럼 사용하는 것이다.

`이 Part Lot이 어느 Production Lot에 사용되었다`는 추적 데이터다.  
`이 Part Lot이 어느 위치에 몇 개 남아 있다`는 재고 데이터다.

두 데이터는 연결되지만 같은 책임이 아니다.

| 영역 | 책임 |
|---|---|
| Traceability | 어떤 Lot/Serial에 무엇이 들어갔는지 |
| Inventory | 특정 위치에 수량이 얼마나 있는지 |
| Inventory Transaction | 입고, 출고, 이동, 조정, 생산투입, 생산입고 이력 |
| Inventory Reservation | 생산 오더나 출하 예정분에 필요한 재고 선점 |

초기 설계에서는 다음 원칙을 지키는 것이 좋다.

- 재고 잔량은 Inventory Balance의 책임으로 둔다.
- 재고 수불은 append-only 이벤트로 기록한다.
- 수정이 필요하면 기존 수불을 고치기보다 반대 수불 또는 조정 수불을 추가한다.
- 생산 오더 release 이후 재고 예약을 만들 수 있게 한다.
- 생산 투입 시 예약을 실제 수불로 전환할 수 있게 한다.
- Trace Link로 재고 잔량을 계산하지 않는다.

## 6. FMS는 BOM과 Inventory 사이의 실행 기록이다

FMS를 Factory Management System 또는 생산 실행 관리 영역으로 본다면, FMS는 `무엇을 만들지`와 `실제로 어떻게 만들었는지` 사이에 위치한다.

BOM은 제품 구조를 정의한다.  
Inventory는 재고 수량의 원본이다.  
FMS는 생산 오더, 공정, 작업 실적, 검사 결과를 관리한다.

초기에는 FMS 전체를 만들기보다 다음 연결점만 미리 열어두면 된다.

| 위치 | 확장 참조 |
|---|---|
| Production Order | 재고 예약, Route Revision |
| Production Lot | 생산 투입/입고 요약, 공정 실행 요약 |
| Operation Result | 생산 Lot 또는 Serial 기준 작업 실적 |
| Work Instruction | 공정별 작업 지시와 검사 기준 |

이렇게 설계하면 나중에 다음 기능으로 자연스럽게 확장할 수 있다.

- Route 관리
- Operation 관리
- 작업 지시 관리
- 생산 오더별 공정 현황
- 작업자·설비·검사 결과 기록
- 불량 수량과 재작업 이력 관리

중요한 것은 FMS가 BOM을 대체하지 않는다는 점이다.  
BOM은 무엇을 만들지의 기준이고, FMS는 어떻게 만들었는지의 실행 기록이다.

같은 BOM이라도 생산 공정은 바뀔 수 있다.  
따라서 Route와 Operation도 BOM과 별도의 Revision을 가지는 편이 안전하다.

## 7. 원가와 단가는 분리한다

원가(Costing)는 생산·구매·재무 관점이다.  
단가(Pricing)는 판매·계약 관점이다.

둘 다 돈과 관련되어 있지만 질문이 다르다.

- 이 제품을 만드는 데 기준상 얼마가 드는가?
- 이번 Production Lot은 실제로 얼마가 들었는가?
- 이 Configuration을 고객에게 얼마에 판매할 것인가?
- 특정 고객군과 기간에 적용되는 가격표는 무엇인가?

원가 롤업은 BOM Revision 기준으로 계산하는 것이 좋다.  
실제원가는 Production Lot 기준으로 확정된다.

초기 설계에서는 다음 정도만 준비하면 충분하다.

- BOM Line에 추후 원가 계산 대상 여부를 둘 수 있는 확장 필드
- Configuration에 판매단가 참조를 둘 수 있는 확장 필드
- Production Lot에 생산 당시 원가 스냅샷을 둘 수 있는 확장 필드
- Cost Version과 Price List를 나중에 별도 도메인으로 분리할 수 있는 구조

---

# III. 플랫폼화 기준: 기능이 아니라 확장 가능한 기준을 만든다

하드웨어 ERP 초기 설계의 최종 목적은 특정 화면 몇 개를 만드는 것이 아니다.  
반복되는 운영 문제를 표준화하고, 이후 기능이 같은 기준 위에 올라갈 수 있도록 플랫폼화하는 것이다.

플랫폼화란 모든 기능을 공통화한다는 뜻이 아니다.  
각 도메인의 책임을 지키면서도 공통 규격, 공통 상태, 공통 감사, 공통 조회, 공통 내보내기 방식이 반복 가능해지는 상태를 말한다.

## 1. 용어는 한글 화면명과 영문 도메인 용어를 함께 관리한다

ERP 용어는 처음 접하는 사용자에게 어렵다.  
그렇다고 화면과 문서에서 임의의 쉬운 표현만 쓰면 개발, 운영, 회계, 생산관리 사이의 의미가 어긋난다.

따라서 화면, 문서, API 계약에서는 한글명과 영문 도메인 용어를 함께 관리하는 것이 좋다.

| 한글 화면 용어 | 영문 도메인 용어 |
|---|---|
| 하드웨어 제품 | Product / Product Master |
| 하드웨어 모델 | Product Model / Configurable Product Model |
| 제품 구성 결과 | Configuration / Product Variant |
| 옵션 그룹 | Option Group / Attribute Group |
| 옵션 값 | Option Value / Attribute Value |
| 옵션 조합 규칙 | Configuration Rule / Constraint |
| 파트 | Part / Item / Material |
| 어셈블리 | Assembly / Subassembly |
| BOM / 자재명세 | BOM / Bill of Materials |
| 리비전 | Revision / Version |
| 생산 오더 | Production Order / Work Order |
| 생산 로트 | Production Lot / Batch |
| 부품 로트 | Part Lot / Batch |
| 시리얼 | Serial / Unit |
| 추적 링크 | Trace Link |
| 품질 보류 | Quality Hold |
| 재고 수불 | Inventory Transaction / Stock Movement |
| 재고 예약 | Inventory Reservation / Allocation |
| 공정 경로 | Route / Routing |
| 공정 작업 | Operation |
| 작업 실적 | Production Execution / Operation Result |
| CSV 출력 | CSV Export / Data Export |
| 내보내기 작업 | Export Job |

표기 원칙은 단순하다.

- 메뉴명과 버튼명은 한글을 우선한다.
- 상세 화면 제목과 도움말에는 영문 도메인 용어를 병기한다.
- API, DTO, 데이터 필드는 영문 도메인 용어를 사용한다.
- 테이블 컬럼 공간이 부족하면 한글을 쓰고 tooltip 또는 도움말에 영문 용어를 둔다.

이렇게 해야 현장 사용자는 익숙한 언어로 작업하고, 시스템은 표준 ERP 용어와 연결될 수 있다.

## 2. 표준 ERP에 맞는 데이터 규격을 먼저 정의한다

ERP 성격의 시스템은 화면을 먼저 만드는 방식으로 설계하면 오래 버티기 어렵다.  
화면은 바뀔 수 있지만 기준정보, 변경 이력, 실물 추적, 재고, 원가의 책임은 오래 유지되어야 한다.

따라서 초기 설계에서는 특정 저장소나 프레임워크보다 먼저 데이터 규격을 정의해야 한다.  
표준 ERP에 준수한다는 것은 특정 제품의 용어를 그대로 따라 쓰는 것이 아니라, 업무 책임과 데이터 생명주기를 명확히 나누는 것이다.

초기에는 다음 기준으로 도메인을 나누는 편이 안전하다.

| 도메인 | 표준 책임 |
|---|---|
| Product Master | 제품, 모델, 옵션, 옵션 규칙, 구성 결과 |
| Product Structure | Part, Assembly, BOM, Revision, BOM Line |
| Production Control | Production Order, Production Lot, Serial, Trace Link |
| Quality Management | 품질 보류, 검사 결과, 리콜 대상, 영향 범위 |
| Costing | 표준원가, 실제원가, 원가 롤업, 원가 버전 |
| Pricing | 판매단가, 가격표, 적용 기간, 고객군별 가격 |
| Inventory Management | 재고 위치, 재고 잔량, 재고 수불, 재고 예약 |
| Manufacturing Execution | Route, Operation, 작업 지시, 작업 실적 |
| Data Export | CSV 출력 작업, 내보내기 템플릿, 생성 이력 |

각 데이터 규격은 최소한 다음 항목을 가져야 한다.

| 규격 항목 | 정의 기준 |
|---|---|
| Ownership | 어떤 도메인이 원본인지 |
| Identifier | 시스템 식별자와 업무 식별자 |
| Lifecycle Status | 작성, 검토, 승인, 사용 중지 같은 상태 |
| Revision Policy | 변경 시 수정인지 새 Revision 발행인지 |
| Effective Date | 적용 시작일과 종료일 |
| Traceability | 어떤 상위·하위 데이터와 연결되는지 |
| Snapshot Policy | 과거 이력 보존을 위해 어떤 값을 복사해둘지 |
| Access Control | 누가 조회·생성·수정·승인할 수 있는지 |
| Audit Trail | 생성, 변경, 승인, 폐기 이력을 어떻게 남길지 |

이 기준이 없으면 같은 필드라도 화면마다 의미가 달라진다.  
예를 들어 `status`가 어떤 화면에서는 판매 가능 여부이고, 다른 화면에서는 생산 가능 여부이며, 또 다른 화면에서는 품질 상태라면 운영자는 데이터를 신뢰하기 어렵다.

## 3. 조회와 검색은 기능이 아니라 계약이다

조회와 검색도 규격으로 정의해야 한다.

| 조회 유형 | 정의 기준 |
|---|---|
| Master Lookup | 제품, 모델, Part, BOM 같은 기준정보 단건 조회 |
| Hierarchy Lookup | Product → Model, BOM → BOM Line 같은 계층 조회 |
| Trace Lookup | Serial → Lot → Part Lot 같은 정방향 추적 |
| Reverse Trace Lookup | Part Lot → Production Lot → Serial 같은 역추적 |
| Status List | 승인 대기, 품질 보류, 생산 중 같은 상태별 목록 |
| Effective Lookup | 특정 일자에 유효한 가격, 원가, BOM, Route 조회 |
| Export Query | 화면 조회 조건과 동일한 기준의 데이터 반출 |

검색은 단순 편의 기능이 아니라 운영 계약이다.  
어떤 필드를 정확 검색할 수 있는지, 어떤 필드는 prefix 검색만 허용하는지, 어떤 필드는 별도 검색 색인이 필요한지 명시해야 한다.

정렬도 같은 기준을 따른다.

- 각 목록 화면은 기본 정렬과 허용 정렬을 명시한다.
- 허용되지 않은 정렬은 조용히 무시하지 않고 실패시킨다.
- 상태 필터는 단순 후처리 필터가 아니라 조회 계약의 일부로 정의한다.
- 검색 키워드는 정확 검색, prefix 검색, token 검색을 구분한다.
- 모든 문자열을 하나의 `keyword` 필드에 넣고 전체 순회로 찾는 방식은 운영 목록에서 사용하지 않는다.
- 검색 token은 원본 데이터 생성, 수정, 삭제와 함께 갱신되어야 한다.
- 삭제는 가능하면 soft delete를 우선하고, 검색 대상에서는 제거한다.

플랫폼화된 ERP 기능은 다음 원칙을 따른다.

- 기준정보와 거래 이력을 분리한다.
- 기준정보 변경은 Revision 또는 유효기간으로 관리한다.
- 생산·출고·품질 이력은 과거 기준을 보존한다.
- 상태값은 도메인별로 명확히 정의한다.
- 식별자는 시스템 ID와 업무 코드로 분리한다.
- 조회 조건, 정렬, 검색 가능 필드는 API 계약으로 문서화한다.
- 대량 반출과 감사 이력은 별도 운영 기능으로 본다.

## 4. CSV Export도 플랫폼 기능이다

ERP 성격의 시스템에서 CSV 출력은 부가 기능이 아니다.  
운영자가 데이터를 확인하고, 공유하고, 감사하고, 외부 분석으로 넘기는 기본 기능이다.

하지만 CSV를 단순히 `현재 화면 테이블을 다운로드`로 만들면 나중에 문제가 생긴다.

CSV Export는 다음 정보를 함께 보존해야 한다.

- 조회 조건
- 정렬 조건
- 컬럼 목록
- 컬럼 순서
- 요청자
- 생성 시각
- 권한과 마스킹 정책

또한 화면 목록 API의 조회 조건과 검색 규격을 재사용해야 한다.  
CSV 전용 전체 데이터 순회를 만드는 순간 운영 데이터가 늘어날수록 문제가 커진다.

초기 기준은 단순하게 잡을 수 있다.

| 방식 | 기준 |
|---|---|
| 동기 CSV 다운로드 | 제한된 row 수 또는 제한된 파일 크기 이하 |
| 비동기 Export Job | 대량 데이터, 역추적 리포트, 복수 데이터 조합 필요 |

CSV는 UTF-8 BOM 포함을 기본값으로 두는 편이 현실적이다.  
현업에서는 여전히 스프레드시트 호환성이 중요하다.

그리고 CSV formula injection도 방어해야 한다.  
`=`, `+`, `-`, `@`로 시작하는 셀은 안전하게 escape해야 한다.

작은 기능처럼 보이지만, 이런 부분이 운영 시스템의 신뢰도를 만든다.

Export Job은 최소한 다음 정보를 가져야 한다.

| 항목 | 의미 |
|---|---|
| Export Type | 어떤 목록 또는 리포트를 출력했는지 |
| Query Snapshot | 검색어, 필터, 정렬, 페이지 범위 |
| Column Snapshot | 컬럼 목록, 순서, 헤더명, 표시 형식 |
| Requested By | 요청자 |
| Status | 요청, 처리 중, 완료, 실패, 만료 |
| File Metadata | 파일 위치, 크기, row 수, 만료 시각 |
| Failure Reason | 실패 원인 |

CSV 출력 API나 화면은 다음 원칙을 따라야 한다.

- 현재 화면의 검색, 필터, 정렬 조건을 그대로 사용한다.
- 권한이 없는 필드와 마스킹 대상 필드는 CSV에도 포함하지 않는다.
- 파일 생성 시점의 조건, 컬럼, 요청자, 생성 시각을 감사 이력으로 남긴다.
- 대량 데이터는 비동기 Export Job으로 처리한다.
- 메뉴별 기본 컬럼과 커스텀 컬럼 허용 여부를 별도 계약으로 정의한다.
- 파일 보관 기간, 다운로드 횟수 제한, 만료 후 삭제 방식을 결정한다.

## 5. 쓰기 일관성과 Fail-Fast를 플랫폼 계약으로 둔다

추적성 데이터는 일부만 저장되면 안 된다.  
다음 작업은 원자적 쓰기 또는 그에 준하는 보상 가능한 쓰기 흐름으로 처리해야 한다.

| 작업 | 함께 성공해야 하는 데이터 |
|---|---|
| Production Lot 생성 | Production Lot, Order to Lot, 상태 변경 이벤트 |
| Serial 발행 | Serial, Lot to Serial, 상태 변경 이벤트 |
| Part Lot 사용 등록 | Consumed Part Lot, Reverse Trace, 상태 변경 이벤트 |
| Quality Hold 등록 | Quality Hold, 대상 Lot/Serial 품질 상태 변경, 감사 이벤트 |

Fail-Fast 계약도 필요하다.

- 존재하지 않는 Product, Model, Configuration, BOM Revision으로 생산 데이터를 만들면 실패한다.
- `RELEASED`가 아닌 Revision은 Production Order나 Production Lot에 연결할 수 없다.
- Production Order 생성에는 모델, 구성, BOM Revision, 계획 수량이 필수다.
- 품질 상태 변경은 이전 상태와 요청 상태가 충돌하면 실패한다.
- 허용되지 않은 정렬, 검색 조건, CSV 컬럼 요청은 실패한다.
- 비동기 Export에 필요한 저장소나 보관 정책이 설정되지 않았다면 요청 시점에 실패한다.

이 원칙은 사용자를 불편하게 만들기 위한 것이 아니다.  
운영 데이터가 조용히 잘못 쌓이는 것을 막기 위한 최소한의 방어선이다.

## 6. 권한과 감사는 도메인별로 다르지만 방식은 공통이어야 한다

권한은 역할별로 다르게 부여하되, 판단 방식과 감사 방식은 공통화해야 한다.

| 역할 | 권한 기준 |
|---|---|
| 제품 관리자 | Product, Model, Option, Configuration 작성과 release |
| 설계 관리자 | Part, Assembly, BOM, Revision 작성과 release |
| 생산 관리자 | Production Order, Production Lot 생성과 release |
| 생산 담당자 | 사용 Part Lot 등록, Serial 발행 |
| 품질 관리자 | Lot/Serial 품질 상태 변경, 영향 범위 조회 |
| 운영 조회자 | 읽기 전용 조회 |

권한 원칙은 다음과 같다.

- `RELEASED` 상태의 Revision은 직접 수정할 수 없다.
- 생산 오더와 생산 Lot 생성은 `RELEASED` 모델, 구성, BOM Revision만 허용한다.
- 품질 보류와 리콜 상태 변경은 품질 권한을 가진 사용자만 수행한다.
- 모든 상태 변경은 actor snapshot과 변경 사유를 남긴다.
- CSV 출력은 해당 목록 조회 권한이 있는 사용자만 수행한다.
- CSV 컬럼 권한은 화면 권한과 동일하게 적용한다.
- CSV 출력 요청과 다운로드도 감사 이력에 남긴다.

## 7. 남겨둘 결정 사항을 명시한다

초기 설계에서 모든 정책을 확정할 수는 없다.  
중요한 것은 미결정 사항을 숨기지 않고, 나중에 결정해야 할 주제로 남겨두는 것이다.

다음 항목은 1차 설계 이후 별도로 결정해야 한다.

| 결정 사항 | 질문 |
|---|---|
| 옵션 규칙 표현 방식 | 단순 허용·금지 규칙으로 충분한가, 조건식 기반 규칙이 필요한가 |
| 검색 token 정책 | 단어 token만 지원할 것인가, 언어별 부분검색까지 지원할 것인가 |
| BOM View 범위 | 1차에서 MBOM만 다룰 것인가, EBOM/Service BOM까지 확장할 것인가 |
| Serial 부여 정책 | 모든 완제품에 부여할 것인가, 중요 부품에도 부여할 것인가 |
| Part Lot 추적 수준 | 모든 부품 Lot을 추적할 것인가, 중요 부품만 추적할 것인가 |
| Route / Operation 범위 | 작업 순서만 기록할 것인가, 작업자·설비·검사 결과까지 기록할 것인가 |
| CSV 컬럼 템플릿 | 메뉴별 고정 컬럼만 허용할 것인가, 사용자별 컬럼 설정을 허용할 것인가 |
| CSV 보관 정책 | 파일 보관 기간, 다운로드 횟수 제한, 만료 후 삭제 방식을 어떻게 둘 것인가 |
| 권한 모델 | 역할 기반만 사용할 것인가, 조직·현장·제품군 단위 권한까지 둘 것인가 |
| 원가 확정 시점 | 생산 완료와 원가 확정을 같은 시점으로 볼 것인가, 별도 재무 확정 단계로 둘 것인가 |

다음 액션도 명확해야 한다.

1. 운영 메뉴명과 메뉴별 책임을 확정한다.
2. Product / Model / Option의 최소 데이터 계약을 작성한다.
3. BOM Revision과 BOM Line 저장 계약을 확정한다.
4. Production Order, Production Lot, Serial의 연결 규칙을 확정한다.
5. 품질 역추적 조회의 1차 조회 패턴을 확정한다.
6. 화면별 검색 필드와 허용 정렬 목록을 확정한다.
7. 메뉴별 CSV 기본 컬럼과 대량 출력 기준을 확정한다.
8. 권한, 감사, 상태 변경 사유 기록 방식을 확정한다.

미결정 사항을 문서화하는 것은 설계가 덜 끝났다는 뜻이 아니다.  
오히려 운영 리스크를 숨기지 않고 관리한다는 뜻에 가깝다.

## 8. 플랫폼화 판단 기준

기능을 플랫폼으로 끌어올릴지는 다음 기준으로 판단한다.

| 기준 | 플랫폼화 신호 |
|---|---|
| 반복성 | 여러 메뉴에서 같은 조회, 상태, 승인, 내보내기 흐름이 반복된다. |
| 확장성 | 새 도메인이 붙을 때 기존 구조를 복사하지 않고 같은 규격을 재사용할 수 있다. |
| 감사성 | 누가, 언제, 무엇을, 왜 바꾸었는지 공통 방식으로 추적해야 한다. |
| 권한성 | 도메인마다 권한은 다르지만 권한 판단 방식은 공통화할 수 있다. |
| 이력성 | 과거 기준을 보존해야 하는 데이터가 많아진다. |
| 연동성 | 외부 시스템과 기준정보, 생산 이력, 재고, 원가를 주고받아야 한다. |

반대로 다음 상태라면 아직 플랫폼화보다 단일 기능으로 두는 편이 낫다.

- 한 메뉴에서만 쓰인다.
- 업무 규칙이 아직 자주 바뀐다.
- 공통화하면 오히려 예외 처리가 늘어난다.
- 데이터 소유권이 불명확하다.
- 운영자가 실제로 사용할 흐름이 검증되지 않았다.

플랫폼화는 추상화를 먼저 만드는 일이 아니다.  
반복되는 운영 기준이 검증된 뒤, 그 기준을 여러 도메인에서 재사용할 수 있게 만드는 일이다.

---

# 마무리: 프로젝트는 작게, 철학은 단단하게, 플랫폼은 늦지 않게

스타트업은 대형 ERP 제품군의 모든 기능을 복제할 필요가 없다.  
그런 방식은 속도도 맞지 않고, 팀의 운영 성숙도와도 맞지 않는다.

하지만 ERP가 오랜 시간 정리해온 기본 경계는 무시하면 안 된다.

- Product와 Serial을 분리한다.
- PIM은 판매 가능한 구성을 정의한다.
- BOM은 생산 가능한 물리 구조를 정의한다.
- Revision은 이미 생산된 이력을 보호한다.
- Lot과 Serial은 실물 추적의 기준이다.
- Traceability와 Inventory는 책임이 다르다.
- FMS는 BOM과 Inventory 사이의 실행 기록이다.
- Costing과 Pricing은 분리된 도메인으로 둔다.
- CSV Export도 운영 감사 기능으로 설계한다.
- 조회·검색·정렬 가능 범위는 데이터 규격의 일부로 정의한다.

초기 프로젝트의 목적은 모든 기능을 한 번에 만드는 것이 아니다.  
나중에 필요한 기능이 생겼을 때 기존 데이터를 부수지 않고 확장할 수 있게 하는 것이다.

좋은 스타트업 ERP 설계는 작게 시작한다.  
하지만 작게 시작하더라도 기준정보, 제품 구조, 실물 추적, 품질 이력의 경계는 처음부터 명확해야 한다.

그 경계가 잡혀 있으면 PIM, SCM, BOM, FMS, Inventory, 원가분석은 순서대로 붙일 수 있다.  
그 경계가 없으면 어떤 ERP를 붙여도 결국 다시 수작업 장부로 돌아간다.
