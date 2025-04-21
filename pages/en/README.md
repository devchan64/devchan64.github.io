# 📝 devchan64.github.io

**A personal tech blog built with Jekyll + GitHub Pages**

[👉 Visit the blog](https://devchan64.github.io)

---

## 📌 Project Overview

This blog is a lightweight platform that combines a **static site generator** and **client-side rendering (CSR)**  
to enable **search, automated translation, and data visualization** — all with minimal server infrastructure.

> Designed as a _searchable archive of structured thinking_, this blog balances **scalability** and **maintenance-free operations**.

---

## 🛠 Tech Stack

| Layer             | Technology                                      |
|------------------|--------------------------------------------------|
| Static Generator | [Jekyll](https://jekyllrb.com/)                 |
| Styling          | Sass (modular SCSS)                             |
| CI/CD            | GitHub Actions + GitHub Pages                   |
| Data Backend     | [Supabase](https://supabase.com/)               |
| AI Integration   | [OpenAI API (GPT-4 Turbo)](https://platform.openai.com/) |

---

## 🎯 Architectural Choices

### ✅ Why Client-Side Rendering (CSR)?
- Enables interactive features like **Pagefind search**, views tracking, and dynamic translation
- Allows static content to support **real-time, on-demand interactions** without full server rendering

### ✅ Why Minimal Server Infrastructure?
- Built on **GitHub Pages** to reduce deployment and infrastructure complexity
- Uses **serverless APIs** (Supabase, OpenAI) for dynamic features
- Eliminates the need to maintain any custom server

---

## ✨ Key Features

### ✅ Markdown-Based Content Management
- Blog posts are stored in the `_posts/` folder
- Metadata handled via YAML frontmatter (`title`, `tags`, `date`, `lang`, etc.)

### 🌍 OpenAI-Powered Auto Translation
- Detects updated posts and auto-generates English translations
- Translated files saved under `_posts/en/`
- Automated PRs created via GitHub Actions

### 📈 Supabase-Based Page View Tracking
- Tracks views by page slug using Supabase as backend
- Secure with RLS (Row-Level Security) policies
- Future plan: Add dashboard visualization

### ⚙️ GitHub Actions Automation
- End-to-end CI/CD for build, deploy, translation, and PR creation
- Minimal manual work required → maximizes **sustainability and automation**

---

## 📚 Blog Topics

- Developer philosophy and systems thinking
- IoT architecture and operational experience
- Documentation culture for Digital Transformation (DX)
- Messaging systems and distributed system design notes

---

## 📎 Reference Links

- 🔗 Blog: [https://devchan64.github.io](https://devchan64.github.io)  
- 📘 Supabase config files: `supabase/`  
- 🤖 Auto-translation workflow: `.github/workflows/translate.yml`

---

## 👋 Purpose of This Blog

This blog is a personal lab for practicing a **documentation-first development culture** and a  
**context-driven approach to architecture and design**.

> 💡 “Documentation is an asset. Structured records are reusable — and help systems evolve.”

---

## 📂 GitHub Repository

Explore this project on GitHub:  
[https://github.com/devchan64/devchan64.github.io](https://github.com/devchan64/devchan64.github.io)
