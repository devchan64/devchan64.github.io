# 📝 devchan64.github.io

**Jekyll + GitHub Pages 기반의 개인 기술 블로그**

## 👨‍💻 게으른 개발자의 블로그

이 블로그는 화려한 기술을 자랑하기 위한 공간이 아닙니다.  
오히려, **최소한의 기술로 최대한의 생각을 표현하기 위한 도구**입니다.

- GitHub Pages + Jekyll + Markdown
- 기술적 복잡함 대신, 명료한 사고를 담는 공간
- 설계자의 관점에서 기술을 바라보는 철학

**기술은 생각을 설계하는 수단입니다.**  

[👉 블로그 바로가기](https://devchan64.github.io)

---

## 📌 프로젝트 개요

이 블로그는 **정적 사이트** (**Site Generator**)와 **클라이언트 사이드 렌더링**(**CSR**)의 조합을 통해 **검색 기능, 번역 자동화, 데이터 시각화**까지 가능한 경량 구조로 설계되었습니다.

> "검색 가능한 기록 시스템"을 목표로, **최소한의 서버 운영**으로 **확장성과 유지비용의 균형**을 실현합니다.

---

## 🛠 기술 스택

| 구성 요소        | 사용 기술                                      |
|------------------|-----------------------------------------------|
| Static Generator | [Jekyll](https://jekyllrb.com/)               |
| 스타일링         | Sass (SCSS 구조화)                             |
| 검색         | [pathfind](https://github.com/CloudCannon/pagefind) |
| CI/CD            | GitHub Actions + GitHub Pages                 |
| 데이터 백엔드    | [Supabase](https://supabase.com/)             |
| AI 연동          | [OpenAI API (GPT-4 Turbo)](https://platform.openai.com/) |

---

## 🎯 선택 배경 및 전략

### ✅ 클라이언트 사이드 렌더링 (CSR)
- **Pagefind** 기반 검색 기능을 위해 CSR 방식 도입
- 정적 콘텐츠 환경에서도 **인터랙티브 기능**(검색, 조회수, 번역 등) 제공

### ✅ 최소한의 서버 운영
- GitHub Pages를 기반으로 인프라 운영 부담 최소화
- 서버리스 구성 (Supabase, OpenAI API)으로 **유지보수 최소화**
- 서버 직접 운영 없이도 **데이터 기록 및 API 호출 기능 확장**

---

## ✨ 주요 기능

### ✅ Markdown 기반 콘텐츠 관리
- `_posts/` 폴더에서 포스트 작성 및 관리
- YAML Frontmatter로 메타 정보 구성 (`title`, `tags`, `date`, `lang` 등)

### 🌍 OpenAI 기반 자동 번역
- 긴 문서도 누락을 줄일 수 있도록 섹션 단위로 영어 번역
- `_posts/en/` 폴더에 번역글 저장
- GitHub Actions로 변경 포스트 갱신 및 전체 영문 문서 재생성 지원
- 수동 실행 시에는 `flagged_order`, `repair_limit`, `full_regeneration` 입력으로 수리 범위를 제어

### 📈 Supabase 기반 페이지 조회수 추적
- 슬러그(URL) 기준으로 페이지별 조회수 저장
- RLS 정책 적용 → 클라이언트에서 직접 조회 가능

### ⚙️ GitHub Actions 자동화
- PR 생성, 번역 처리, 배포까지 자동화된 CI/CD 구성
- 수동 개입 최소화를 통한 **지속 가능성 확보**

### 🎞 Marp 기반 슬라이드 자동 생성
- `_slides/` 경로에 `.md` 파일만 작성하면 GitHub Actions가 HTML 슬라이드 자동 생성
- 커스텀 테마를 적용해 발표자료의 브랜드 정체성 유지
- 마크다운으로 발표 자료를 관리 → 블로그와 슬라이드를 통합된 문서 시스템으로 운영

### 📐 D2 및 Mermaid 기반 다이어그램 시각화
- Jekyll + Client-Side Rendering(CSR) 구조 덕분에 Mermaid, D2 사용 가능
- 코드 블록에 다이어그램을 직접 작성 → 유지보수 및 수정 용이
- 설계 문서, 시스템 아키텍처, 프로세스 흐름 등을 시각적으로 표현 가능

---

## 📚 블로그 주제

### 🧠 설계 철학과 조직 문화  
구조적 사고, 기술 철학, 협업 구조 설계 등 소프트웨어 외부의 구조를 고민합니다.

### 👥 애자일 리더십과 고객 중심 개발  
고객 관점에서 출발하는 문제 정의, 페르소나 기반 설계, 실행력 중심 애자일 운영.

### 🔧 DX + DevOps 전략  
작은 팀을 위한 실용적 DevOps와 자동화, 지식관리와 협업 기반 개발 문화 설계.

### 📡 메시징 시스템 및 분산 설계 노트  
ROS, IoT, 메시지 브로커, FSM 기반 에이전트 설계 등 운영 중심 분산 구조 기록.

### 🧹 삭제 준비(Expiry-Ready)된 구조 설계  
리팩토링이 전제된 시스템 구성, 모노레포와 AWS 인프라 설계 철학.

---

## 📎 참고 링크

- 🔗 블로그: [https://devchan64.github.io](https://devchan64.github.io)
- 📘 Supabase 설정 파일: `supabase/`
- 🤖 번역 자동화 스크립트: `.github/workflows/translate.yml`
- ♻️ 영문 번역 재생성/수리는 GitHub Actions `Translate Markdown Posts` workflow에서 수행

---

## 👋 블로그의 목적

이 블로그는 "**기록은 자산이다**"라는 철학 아래,  
**개발자의 관점으로 구조화된 사고와 설계 노하우**를 공유하고자 만든 공간입니다.

> 💡 “기록은 자산이다. 구조화된 기록은 재사용 가능하며, 시스템을 진화시킨다.”

---

## 📂 GitHub 저장소

GitHub에서 이 프로젝트를 확인하세요:  
[https://github.com/devchan64/devchan64.github.io](https://github.com/devchan64/devchan64.github.io)
