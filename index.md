---
layout: default
title: "Welcome to My Blog"
date: 2024-04-01
---

<header>
  <h1>{{ site.title }}</h1>      
</header>
<main class="post-content">
  <h2># Recent Posts</h2>

  <ul id="post-list"></ul>

  <button id="load-more" class="button" >더 보기</button>
</main>
<script>
let posts = [];
let currentIndex = 0;
const postsPerPage = 5;

const tagsSet = new Set();

function getQueryParam(name) {
  const url = new URL(window.location.href);
  return url.searchParams.get(name);
}

function loadFilteredOrAllPosts() {
  const selectedTag = getQueryParam('tag');

  if (selectedTag) {
    const filtered = posts.filter(post => post.tags.includes(selectedTag));
    renderPosts(filtered);
  } else {
    renderPosts(posts);
  }
}

async function loadPosts() {
  if (posts.length === 0) {
    const res = await fetch('/posts.json');
    posts = await res.json();

    posts.forEach(post => {
      post.tags.forEach(tag => tagsSet.add(tag));
    });

    renderFilters();
  }

  loadFilteredOrAllPosts();
}

function renderFilters() {
  const tagList = document.getElementById('tag-list');

  tagsSet.forEach(tag => {
    const li = document.createElement('li');
    li.innerHTML = `<a href="?tag=${encodeURIComponent(tag)}">${tag}</a>`;
    tagList.appendChild(li);
  });
}

function renderPosts(list = posts) {
  const container = document.getElementById('post-list');
  container.innerHTML = '';

  const nextPosts = list.slice(0, postsPerPage);
  nextPosts.forEach(post => {
    const li = document.createElement('li');
    li.innerHTML = `
      <a href="${post.url}">${post.title}</a> - <small>${new Date(post.date).toLocaleDateString()}</small>
      <p>${post.excerpt}</p>
      <div class="meta">
        <span>🏷️ ${post.tags.join(', ')}</span>
      </div>
      <hr/>
    `;
    container.appendChild(li);
  });

  const moreBtn = document.getElementById('load-more');
  moreBtn.style.display = list.length > postsPerPage ? 'block' : 'none';
}

function filterBy(type, value) {
  const filtered = posts.filter(post => {
    return post.tags.includes(value); // 카테고리 제거됨
  });
  renderPosts(filtered);
}

document.getElementById('load-more').addEventListener('click', loadPosts);
window.addEventListener('DOMContentLoaded', loadPosts);
</script>