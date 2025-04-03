---
layout: default
title: "Welcome to My Blog"
date: 2024-04-01
---

# Recent Posts

<ul id="post-list"></ul>

<button id="load-more">더 보기</button>

<script>
let posts = [];
let currentIndex = 0;
const postsPerPage = 5;

async function loadPosts() {
  if (posts.length === 0) {
    const res = await fetch('/posts.json');
    posts = await res.json();
  }

  const nextPosts = posts.slice(currentIndex, currentIndex + postsPerPage);
  const container = document.getElementById('post-list');

  nextPosts.forEach(post => {
    const li = document.createElement('li');
    li.innerHTML = `
      <a href="${post.url}">${post.title}</a> - <small>${new Date(post.date).toLocaleDateString()}</small>
      <p>${post.excerpt}</p>
    `;
    container.appendChild(li);
  });

  currentIndex += postsPerPage;

  // 더 이상 불러올 게 없으면 버튼 제거
  if (currentIndex >= posts.length) {
    document.getElementById('load-more').style.display = 'none';
  }
}

document.getElementById('load-more').addEventListener('click', loadPosts);
window.addEventListener('DOMContentLoaded', loadPosts);
</script>