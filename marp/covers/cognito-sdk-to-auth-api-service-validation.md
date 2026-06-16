---
marp: true
size: 4:3
---

<!-- _class: lead, invert -->

## Cognito로 빠르게 Auth API 만들기

### SDK 호출을 서비스 계약으로 감싸고  
### OAuth/OIDC 경계로 확장합니다

<div class="mermaid">
flowchart LR
  A[Cognito] --> B[Auth API]
  B --> C[User Context]
  B --> D[Access Token]
  D --> E[Protected API]
  C --> F[Policy / Role / Tenant]
</div>
