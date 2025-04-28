---
marp: true
size: 4:3
---

# 브랜드 사이트 DX-OPS

- 🧱 **삭제 준비(Expiry-Ready)된 구조**  
- 🔄 **자동화된 콘텐츠 배포**  
- 🔍 **콘텐츠를 코드처럼 다룬다**  
- 🚀 **빠르게 만들고 빠르게 바꾼다**  

<div class="mermaid">
flowchart LR
  Figma[Figma - 디자인 가이드] --> UI[Astro + Tailwind - UI 구현]
</div>

<div class="mermaid">
flowchart LR
  Notion[Notion - 콘텐츠 작성] --> MD[Markdown 변환]
  MD --> PR[PR 생성 + Preview 배포]
  PR --> QA[시각 검토 & 승인]
  QA --> PROD[Production 배포]
</div>