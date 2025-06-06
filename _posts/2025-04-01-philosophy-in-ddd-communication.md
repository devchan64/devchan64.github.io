---
layout: post
title: "철학을 도구화하지 말자 – 본질은 커뮤니케이션이다 (feat. DDD)"
date: 2025-04-01
tags: [설계철학, 언어정렬]
---

### 모델링은 대화입니다. 구조는 그 결과일 뿐입니다.

최근 들어 도메인 주도 설계(DDD, Domain-Driven Design)가 다양한 커뮤니티와 실무 현장에서 자주 언급되고 있습니다.  
이는 제품 개발 방식의 변화와도 깊은 관련이 있습니다.

복잡한 시스템을 잘게 나누고,  
도메인 모델을 중심으로 구조화하며,  
**언어 정렬**하는 이 접근 방식은  
많은 이들에게 **올바른 설계 방법론**으로 보일 수 있습니다.

---

### 하지만 저는 조금 다른 관점에서 DDD를 바라보고 있습니다.

기존의 폭포수 방식에서는 절차와 문서화된 계획이 중요했다면,  
스타트업 환경에서는 빠른 피드백 루프와 유연한 대응이 중요해졌습니다.  
이 변화 속에서 커뮤니케이션의 중요성이 다시 강조되고 있으며,  
그 흐름 속에서 DDD가 주목받고 있는 것입니다.

---

### DDD는 엄밀히 말해 도구가 아닙니다.

DDD는 설계의 철학이며,  
그 철학의 핵심은 '커뮤니케이션'에 있습니다.

도메인을 잘게 나누는 것도,  
경계를 정의하는 것도,  
용어를 통일하는 것도  
결국은 **사람 간의 사고를 정렬하고 소통을 원활하게 만들기 위한 수단**입니다.

이 점을 간과한 채, 구조와 계층, 패턴을 따라가는 것에 집중하면 오히려 본질에서 멀어지게 됩니다.

---

저는 개인적으로 `Service`, `Feature`, `Function`이라는 표현 체계를 중심으로 팀 내 언어를 정리하고 있습니다.  
이는 유비쿼터스 언어라는 개념과 겹칠 수 있지만, 더 명확하고 실무적인 기준을 제시해줍니다.  
중요한 것은 그 표현 방식이 무엇이든 간에, **사람의 사고와 시스템의 구조가 최대한 유사하게 정렬되도록 만드는 것**입니다.  
그 과정에서 DDD는 철학적 사고의 보조 수단일 뿐, 목적이 되어서는 안 됩니다.

---

### 우리가 설계하는 시스템은 사람의 사고를 구조화한 결과물입니다.

코드는 사고를 담는 매개체이며, 시스템은 그 사고가 작동하는 구조입니다.  
이러한 맥락에서 본다면 설계란 곧 '대화'이고, 모델링은 그 대화의 결과일 뿐입니다.  
복잡한 설명과 개념은, 결국 사람의 사고를 더 정밀하게 반영하기 위한 불가피한 산물일 뿐입니다.

---

### **시스템 사고를 언어로 표현한 결과가 디자인 패턴이 되고, 시스템 설계가 됩니다.**

**언어 정렬**을 문화와 시스템에 녹인다는 것은 매우 매력적인 일입니다.  
이는 설계자가 단순히 구조를 만드는 기술자에 머무르지 않고, 사고와 철학에 관심을 가져야 하는 이유이기도 합니다.  
이것이야말로 설계가 수행해야 할 핵심적인 역할이라고 생각합니다.

---

### 그렇기 때문에 **언어 정렬**이 가장 중요합니다.

이 정렬만으로도 많은 커뮤니케이션 문제는 해소될 수 있습니다.

우리는 과거에도 `기능 명세서`, `기능 목록`, `피처 목록`과 같은 방식으로 **언어 정렬**하려는 시도를 꾸준히 해왔습니다.  
이러한 노력은 스타트업 문화가 자리잡고,

빠른 개발과 모듈화가 우선시되면서 점차 흐려졌고,  
그 결과 도메인 간 **언어 정렬**이 무너진 현상이 나타나기 시작했습니다.  
저는 이것이 DDD가 다시 강조되는 이유 중 하나라고 생각합니다.

그리고 이러한 **언어 정렬**의 필요성을 실무에서 일회성으로 도입하거나 특정 도구로 해결하려는 실수는 피해야 합니다.

이는 설계 도구나 기법으로 해결할 수 있는 문제가 아니라,  
리더십 차원에서 방향성과 기준을 제시해야 할 문제입니다.

DDD는 새로운 개념이 아니라, 우리가 잃어버린 **언어 정렬**이라는 기본으로 돌아가자는 움직임일지도 모릅니다.
