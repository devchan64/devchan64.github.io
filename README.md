# 📝 devchan64.github.io

**Jekyll + GitHub Pages 기반의 개인 기술 블로그**

[👉 블로그 바로가기](https://devchan64.github.io)

---

## 📌 프로젝트 개요

이 저장소는 Jekyll, Sass, GitHub Actions, Supabase, OpenAI API 등을 활용하여  
**정적 사이트이면서도 클라이언트 사이드 렌더링(CSR)**이 가능하도록 구성한 개인 블로그입니다.  
개발 철학, 시스템 설계, IoT 플랫폼 구조, DX 관련 아카이브와 실험을 공유하고 있습니다.

---

## 🛠 기술 스택

- **Static Site Generator**: [Jekyll](https://jekyllrb.com/)
- **Styling**: Sass (SCSS 구조화)
- **배포 및 자동화**: GitHub Actions + GitHub Pages
- **데이터 백엔드**: [Supabase](https://supabase.com/)
- **AI 기능**: [OpenAI API](https://platform.openai.com/) 연동 (GPT-4 Turbo 기반)

---

## ✨ 주요 기능

### ✅ Markdown 기반 콘텐츠 관리
- `_posts/` 디렉토리로 블로그 글 관리
- YAML Frontmatter 기반 메타데이터 설정

### 🌍 OpenAI 기반 자동 번역 및 요약
- 수정된 포스트만 감지하여 영어로 자동 번역
- `_posts/en/` 디렉토리에 번역 파일 생성
- GitHub Actions로 PR 자동 생성 및 승인 요청

### 📈 Supabase 기반 페이지 조회수 기록
- 페이지별 조회수 DB 저장
- RLS 정책을 활용한 보안 설정
- Jekyll 클라이언트에서 조회수 호출 및 표시

### ⚙️ GitHub Actions CI/CD
- Markdown 파일 변경 시 자동 빌드 & 배포
- 조건부 번역 및 PR 자동화
- 정적 사이트용 워크플로우 구성

---

## 📚 블로그 주제

- 개발자 철학과 시스템적 사고
- IoT 기반 아키텍처와 운영 경험
- DX를 위한 문서화와 기록 문화
- 메시징 시스템 및 분산 설계

---

## 📎 참고 링크

- 🔗 블로그 URL: [https://devchan64.github.io](https://devchan64.github.io)
- 📘 Supabase 프로젝트 관리: `supabase/sql/`
- 🤖 번역 자동화 스크립트: `.github/workflows/translate.yml`

---

## 👋 목적과 방향

이 블로그는 **기록 중심의 개발 문화**와 **문맥 기반 설계 철학**을 실천하고자 하는 개인적인 실험장이자,  
커리어 브랜딩과 지식 공유를 위한 퍼블릭 공간입니다.

> "기록은 자산이다. 구조화된 기록은 재사용 가능하며, 시스템을 진화시킨다."

---

