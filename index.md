---
layout: default
title: "Welcome to My Blog"
date: 2024-04-01
---

# Recent Posts

<ul>
  {% for post in site.posts limit:5 %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a> - <small>{{ post.date | date: "%B %d, %Y" }}</small>
      <p>{{ post.excerpt | strip_html }}</p> <!-- excerpt를 단순히 출력, 줄 수는 CSS로 제한 -->
    </li>
  {% endfor %}
</ul>
