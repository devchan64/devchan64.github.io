# 디자인과 콘텐츠를 분리하고, DX로 운영한다

- 🧱 **삭제 가능한 구조**  
  → Tailwind, Notion, Astro는 언제든 교체 가능  
- 🔄 **자동화된 콘텐츠 배포**  
  → Notion 작성 → PR → Preview → 승인 → 배포  
- 🔍 **콘텐츠를 코드처럼 다룬다**  
  → Git 기반 기록, QA 기반 승인  
- 🚀 **빠르게 만들고 빠르게 바꾼다**  
  → 정적 구조 + 자동화 = 빠른 반복

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
