---
title: "좋은 개발자는 어떻게 평가로 성장하는가?"
layout: post
date: 2025-04-16
tags: [조직문화, 리더쉽, 설계철학, 온보딩]
---

성과 평가는 개발자에게 가장 민감하고, 때로는 피로감을 주는 말입니다.  
하지만 진짜 바라는 개발자의 모습이 명확히 정의되어 있다면, 평가는 줄 세우는 도구가 아니라 **성장과 문화의 훈련 방식**이 될 수 있습니다.

어떻게 **좋은 개발자의 기준**을 정의하고, 그 기준을 바탕으로 **성과 평가를 문화로 운영**하며, 궁극적으로 **신뢰할 수 있는 산출물을 팀에 축적하는 구조를 만들 것**인가에 대한 이야기입니다.

---

# 1. 왜 문화를 위한 평가여야 하는가?

개발자의 성과를 평가하는 일은 늘 어렵습니다.  
기능을 빨리 만들었다고 해서 잘했다고 할 수는 없고, 코드를 많이 작성했다고 해서 가치 있는 결과를 만들었다고도 할 수 없습니다.

성과를 수치로만 바라보는 평가 방식은 오히려 **팀을 위축시키고**, 개발자 간의 비교를 유도하며, **협업이 아니라 경쟁을 강화**합니다.

이런 방식 대신, **"우리가 바라는 좋은 개발자란 무엇인가?"** 를 먼저 정의하고, 그 기준을 바탕으로 팀이 **반복적으로 훈련하고 성장할 수 있는 구조**를 만들고자 합니다.

> **평가의 목적은 순위를 정하는 것이 아니라, 팀이 함께 성장할 수 있는 기준을 정립하는 것입니다.**

그리고 이 기준은 문서와 코드에 남는 산출물로 이어지며, 결국 팀 문화 그 자체가 됩니다.

---

# 2. 우리가 바라는 좋은 개발자의 정의

좋은 개발자를 판단하는 기준은 하나로 고정되어 있지 않습니다.  
기술 스택도, 프로젝트도, 팀도 다르기 때문입니다.

**그래서 가장 먼저 해야 할 일은, ‘좋은 개발자란 무엇인가’를 팀이 함께 정의하는 것입니다.**

모든 상황에 통하는 보편적인 기준을 찾기보다는, **우리 팀이 함께 일하고 싶은 개발자는 누구인가?**를 기준 삼아 조금씩 정리해가고 있습니다.

이 정의는 평가표가 아니라, 팀이 성장하면서 스스로 정리되는 **철학과 습관의 모음**입니다.

현재 중요하게 생각하는 기준은 다음과 같습니다:

## 🧼 삭제 준비(Expiry-Ready)된 코드

> **코드는 남기기 위한 것이 아니라, 언제든 삭제할 수 있도록 구조화되어야 합니다.**

기능을 잘 만드는 것보다, **삭제해도 시스템 전체가 무너지지 않는 코드**를 더 높게 평가합니다.  
의존성이 낮고, 책임이 분리되어 있으며, 도메인의 변화에 유연하게 반응할 수 있는 코드가 이상적입니다.

삭제 준비(Expiry-Ready)된 코드를 작성하려면 다음을 고민해야 합니다:

- 이 코드가 어디에 얽혀 있는가?
- 이 기능이 없어질 경우, 어떤 모듈이 영향을 받는가?
- 이 부분을 나중에 대체하거나 제거할 수 있을까?

> **삭제 준비(Expiry-Ready)는 유지보수성과 확장성의 핵심 지표이며, 이러한 구조적 유연성을 팀 문화로 훈련합니다.**

## 🧪 목업 중심의 사고

> **전체 구현보다 먼저, 어떻게 쓰일지를 상상해보는 것이 설계의 시작입니다.**

코드 구현에 앞서 **목업(mock) 코드**를 먼저 작성해보는 습관을 중요하게 생각합니다.  
함수를 어떻게 호출할지, 어떤 결과를 기대할지, 어떤 맥락에서 이 기능이 사용될지를 먼저 상상해보면 **책임과 경계를 훨씬 명확하게 설계할 수 있습니다.**

이런 접근은 다음과 같은 효과를 줍니다:

- 호출자가 원하는 사용법을 먼저 정의할 수 있다
- 지나치게 복잡한 구조를 사전에 걸러낼 수 있다
- 인터페이스의 명확성, 일관성이 높아진다

> **코드를 먼저 짜지 말고, 사용법부터 그려보는 것. 이것을 '목업 중심 사고'라고 할 것 입니다.**

## 🔗 명확한 호출 인터페이스

> **함수나 메서드를 호출할 때, "이건 어떤 역할을 하는 코드지?"라는 질문이 생기지 않아야 합니다.**

좋은 인터페이스는 코드의 복잡함을 감추는 것이 아니라, **맥락을 단순화하고 협업을 원활하게 만드는 설계의 핵심**입니다.

다음과 같은 점을 중요하게 생각합니다:

- 예측 가능한 입력과 출력
- 하나의 책임만 가지는 함수
- 이름만 보고도 맥락을 이해할 수 있는 수준

> **명확한 호출 인터페이스는 협업의 시작점입니다.**

## 🧠 도메인을 이해하는 네이밍

> **이름은 코드에서 가장 먼저 읽히는 설명서입니다.**

변수, 인스턴스, 함수, 클래스의 이름을 통해 **그 코드가 어떤 역할을 하는지를 설명**해야 한다고 믿습니다.

다음 두 가지를 원칙으로 삼습니다:

1. **최소 2단어 이상으로 이름을 짓는다**

   - `data`, `obj` 같은 이름 대신 `userProfile`, `paymentResult`처럼 **도메인 맥락이 드러나는 이름**을 사용합니다.

2. **IDE는 우리의 도구다.**
   - 자동완성이 존재하는 환경에서 긴 이름은 문제가 되지 않습니다.
   - 오히려 **검색, 추적, 협업에 유리한 구조**를 만듭니다.

> **좋은 네이밍은 도메인 이해의 흔적이며, 팀 언어를 정돈하는 첫 걸음입니다.**

## 📝 문서로 남기고 읽는 사람을 고려

> **문서는 설명이 아니라 배려입니다.**

생각한 이유, 선택한 판단, 해결한 문제를 **구조와 이름을 통해 자연스럽게 전달**하는 것을 중요하게 생각합니다.

주석보다 다음을 중요하게 여깁니다:

- 코드의 구조와 네이밍으로 맥락을 설명하는 것
- 함수 이름, 파일 구성, 책임 분리를 통해 흐름이 읽히게 만드는 것
- 복잡한 결정은 위키, PR 설명, README 등에 기록해두는 것

> **코드 자체가 읽히는 구조라면, 그것이 곧 최고의 문서입니다.**

## 📆 유지보수를 고려한 가독성

> **좋은 코드는 지금보다, 나중에 유지보수될 때 평가됩니다.**

코드는 오늘보다 **6개월, 1년 후에 누군가가 고칠 수 있는지**가 더 중요합니다.  
가독성을 단순한 스타일이 아닌, **지속가능성과 협업의 기준**으로 봅니다.

좋은 코드의 특징:

- 역할이 분리되어 있고 중첩이 적다
- 네이밍이 도메인 맥락을 설명한다
- 의도와 판단의 이유가 남아 있다

> **“이 코드를 다른 개발자가 처음 보고도 고칠 수 있을까?”  
> 이 질문에 예라고 답할 수 있다면 성공입니다.**

## 🍝 복잡한 코드라도 설명하는 노력이 필요하다

> 복잡한 코드 자체는 문제가 아닙니다.  
> **설명하지 않고 남겨두는 것이 문제입니다.**

빠르게 대응하거나 복잡한 도메인을 다루는 과정에서 누구나 **스파게티 같은 코드**를 작성할 수 있습니다.
그런 코드를 금지하지 않습니다.

하지만 그 코드를 팀 안에 남긴다면, **그 순간의 판단과 이유를 설명하려는 노력**은 반드시 필요합니다.

중요한 건 **완벽한 문서화가 아닙니다.**

당시 개발자가 남긴

- 몇 줄의 코멘트
- PR 설명
- 위키 링크
- README 한 줄
- 의미 있는 변수명이나 함수명

**무엇이든 '설명하려는 시도' 자체가 그 사람의 성장 의지이자, 팀을 배려하는 태도입니다.**

PR 설명, 위키, README, 주석 등 **어디든 남길 수 있도록 훈련하고, 그것이 팀 문화가 되도록 합니다.**

> **설명이 있는 스파게티 코드는 기술적 판단이고,  
> 설명이 없는 스파게티 코드는 기술적 부채입니다.**

---

# 3. 양보다 ‘무엇을 남겼는가’가 중요하다

성과를 수치로 판단하기 시작하면, 개발자는 빠르게 많은 기능을 만들거나, 더 많은 라인을 작성하는 데 집중하게 됩니다.  
그러나 알고 있습니다.

> **많이 했다고 해서 잘한 것이 아닙니다. 정말 중요한 건, "무엇을 남겼는가?"입니다.**

> 이 코드가 좋은 코드인지 아닌지를 판단하는 가장 단순한 질문은 이것입니다:  
> **“새로운 사람이 와서 이 코드를 보고 이해하고 참여할 수 있는가?”**

이 질문에 “예”라고 대답할 수 있다면, 그 코드는 단지 기능을 수행하는 코드가 아니라 **지식이 살아남는 구조**를 가진 코드이며, **양이 아니라 맥락과 의도를 담은 산출물**입니다.

---

## 다음을 기준으로 삼지 않습니다:

- 커밋 수
- 코드 라인 수
- 기능 개수
- 반복된 수정 횟수

## 대신, 다음을 기준으로 삼습니다:

- **의도를 설명할 수 있는 코드**
- **맥락이 드러나는 문서**
- **읽는 사람을 배려한 구조**

> **이 기준이 반복될 때, 평가가 곧 팀의 언어가 됩니다.**

그리고 이렇게 말합니다:

> **설명 없는 스파게티 코드가 남아 있다면, 그 사람은 아마도 우리 팀이 말하는 ‘좋은 개발자’의 기준을 아직 이해하지 못한 것일지도 모릅니다.**

왜냐하면 팀은 결과물이 아닌 **산출물로 말하는 문화를 가진 팀**이기 때문입니다.

이렇게 생각합니다:

> **어떤 프로젝트이든, 누가 언제 들어오든 온보딩이 가능하도록 정보가 문서로 남아 있어야 합니다.**

여기서 말하는 문서는 꼭 글일 필요는 없습니다.

- `README.md`
- `docker-compose.yml`, `setenv.sh`, `Makefile`, `run.sh`
- DB 초기 스키마, 샘플 데이터
- 프론트엔드 개발용 목업 API
- 테스트를 위한 셸 명령어, seed 파일

**이 모든 실행 가능한 도구들이 곧 온보딩 문서이고, 팀의 배려이며, 문화의 흔적입니다.**

그리고 그 어떤 것도 남아 있지 않다면, 명확히 말합니다:

> **그 사람은 팀의 문화를 이해하지 못했습니다.**

지식을 공유하는 팀이 아닙니다.  
**지식이 살아남게 만드는 팀입니다.**

---

# 4. 평가 구조: 훈련 가능한 3단계

평가를 ‘결과에 대한 판단’이 아니라 **팀 문화를 내재화하고 성장하는 훈련 과정**으로 설계했습니다.

## 평가 단계 요약

| 단계  | 주체      | 목적                             | 핵심 질문                             |
| ----- | --------- | -------------------------------- | ------------------------------------- |
| 1단계 | 자기 평가 | 기준에 맞춰 스스로 돌아보기      | “나는 그렇게 일하고 있는가?”          |
| 2단계 | 다면 평가 | 팀 기준에 대한 공감과 피드백     | “동료는 그렇게 일하고 있는가?”        |
| 3단계 | 팀장 판단 | 도메인 적중도와 실사용 기여 평가 | “이 코드가 실제 비즈니스에 맞았는가?” |

---

## 🪞 자기 평가 – 내재화의 시작

- 개발자는 자신의 작업이 팀 기준에 부합하는지를 회고합니다
- 단순 결과 나열이 아니라, **의도와 맥락 중심의 자기 점검**

## 🤝 다면 평가 – 공감과 확인의 시간

- 동료 간에 **기준에 대한 피드백을 주고받는 과정**입니다
- 서로의 실행이 기준에 얼마나 공감되는지를 나눕니다

> **다면 평가는 공식적인 평가에 반영되어서는 안 됩니다.**  
> 이 과정은 문화 내재화 정도를 점검하기 위한 도구입니다.

- 비교하거나 줄 세우기 위한 수단이 아닙니다
- 오히려 신뢰를 무너뜨릴 수 있는 요소가 될 수 있기에, **문화가 안착되지 않으면 과감히 포기해야 합니다**

> **다면 평가는 훈련과 공감의 도구이며, 공식적인 판단 기준이 아닙니다.**
>
> 오해를 줄이기 위해 평가 발표 이후 시행 할 수도 있습니다

이 과정을 **팀의 문화 이해도와 기준 내재화 정도를 점검하는 용도**로만 사용합니다.  
비교하거나 줄 세우기 위한 도구가 아닙니다.

이를 명확히 인식하지 않으면, 다면 평가는 **신뢰를 구축하기보다 오히려 해치는 요소**가 될 수 있습니다.  
그래서 모든 팀원에게 **“다면 평가는 공감과 훈련을 위한 도구”라는 점을 교육하고 반복 훈련합니다.**

## 🎯 팀장 판단 – 비즈니스 적중도의 해석자

- **도메인 적중도와 실사용 기여도**를 가장 정성적으로 판단합니다
- 팀장 또는 리더는 **산출물이 얼마나 비즈니스 목적에 부합했는지**를 봅니다

이 3단계를 통해  
**정량적인 비교 없이도 정성적인 기준을 반복 훈련**할 수 있다고 믿습니다.

> **성과는 결과가 아니라,  
> 과정 속 기준의 이해와 실행으로부터 드러나야 합니다.**

---

# 5. 사용하는 도구와 구조

평가 기준이 아무리 좋아도,  
그 기준을 **기록하고 반복하며 되돌아볼 수 있는 구조**가 없다면 문화로 정착되기 어렵습니다.

다음과 같은 도구와 습관을 통해 기준이 **자연스럽게 기록되고, 공유되고, 누적될 수 있도록** 팀을 운영합니다.

## 🛠️ PR 리뷰를 하지 않습니다

기능을 만들고 나서 승인받는 전통적인 PR 사이클을 따르지 않습니다.  
**리팩터링을 위한 기준 점검 프로세스**를 운영합니다.

이 프로세스는 코드의 정합성을 확인하는 절차가 아닙니다.  
**팀이 정의한 좋은 개발자의 기준을 함께 읽고, 그 기준을 코드 속에서 훈련하는 구조화된 대화의 시간입니다.**

이 기준은 다음과 같은 질문을 통해 점검됩니다:

- 이 코드는 **삭제 준비(Expiry-Ready)**를 고려하여 설계되었는가?
- **문서 없이도 흐름이 자연스럽게 읽히는가?**
- **목업 중심의 사고로 먼저 사용법을 상상하고 설계되었는가?**
- 복잡한 구조나 구현에 대해, **설명을 누락하지 않았는가?**
- **도메인을 이해하고, 용어와 네이밍이 정렬되어 있는가?**

이 구조를 **‘리팩터링 데이’**라 부르며 스프린트 종료일정에 PR처럼 실행합니다.

> **PR 리뷰를 하지 않습니다.  
> 리팩터링을 위한 프로세스를 운영합니다.  
> 다만, 그 수단으로 Git의 PR 기능을 활용할 뿐입니다.**

리팩터링 데이를 거치면,

- 기준을 점검한 흔적이 남고
- 커밋과 PR, 주고받은 코멘트, 문서화된 의도들이  
  **결과적으로 중요한 산출물로 축적됩니다.**

이 기록들은 단순한 작업 내역이 아니라, **팀의 사고 방식, 도메인 판단, 기술적 맥락이 담긴 지식 자산**입니다.

이 구조에서는 더 이상 '승인자'가 존재하지 않습니다.  
누가 승인하고 누가 피드백을 주는지가 중요한 것이 아니라, **각자 스스로 기준에 따라 코드를 점검하고, 그 기준을 다시 떠올리는 과정 자체가 팀 문화가 됩니다.**

> 자가 검토가 가능해질수록 기준은 더 이상 외부의 피드백이 아니라, **내면화된 습관이 됩니다.**

이런 반복은 결국 팀 전체가 **승인을 받지 않아도 좋은 코드를 만드는 훈련된 집단**이 되도록 만듭니다.

## 📘 지식베이스 (Wiki, Notion 등)

- PR이나 회의, 회고에서 도출된 도메인 이해, 의사결정 흐름을 정리합니다
- 팀 기준을 정리하고 공유하는 중심 허브 역할을 합니다
- **기록이 남을수록, 팀의 기준은 명확해집니다**

## 🪞 자기 평가 & 회고 템플릿

- 스스로 기준을 되짚고 훈련할 수 있도록 돕는 구조
- 반복되는 실행 속에서 **기준이 내재화**될 수 있도록 합니다
- 평가 목적이 아닌 **리마인더와 훈련 도구**로 사용됩니다

## 🧠 팀장용 판단 시트 (정성 평가)

- 수치가 아닌 **도메인 적중도, 실사용 여부, 산출물 완성도**를 중심으로 판단합니다
- 비즈니스 기여와 실행 흔적이 드러나는 산출물 중심 평가
- **사람이 아닌 코드와 기록이 말하게 하는 시스템**을 지향합니다

> 이 도구들을 평가 도구로 보지 않습니다.  
> **팀이 일하는 방식을 반복하고 훈련할 수 있게 만드는 구조**로 봅니다.

# 6. 결론: 평가보다 누적을 설계한다

평가를 통해 사람을 줄 세우고 싶지 않습니다.

> **좋은 개발자란 무엇인가에 대한 공통된 기준을 합의하고**, 그 기준을 기반으로 **팀이 스스로 성장할 수 있는 구조를 만드는 것**입니다.

성과는 숫자로 측정되는 결과가 아니라, **판단의 의도와 도메인 이해가 담긴 산출물**로 확인되어야 합니다.  
그리고 그 산출물은 PR, 문서, 리뷰, 회고 등을 통해 **팀에 누적되는 흔적**으로 남아야 합니다.

## 이렇게 일합니다

- 기준을 먼저 정의하고
- 훈련 가능한 구조를 만들며
- 신뢰 가능한 리뷰 문화를 설계하고
- 반복되는 실행 속에서 기준을 내재화합니다

> **좋은 팀은 평가를 필요로 하지 않습니다.**  
> 기준이 문화로 누적되는 구조 속에서, 팀은 자연스럽게 좋은 개발자를 만들어냅니다.

이것이 평가를 설계한 이유이며, 팀을 운영하는 방식이자, 문화가 작동하는 방식입니다.
