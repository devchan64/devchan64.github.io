const API_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR4d3BuY3hmYXV6c3BucXd3YnhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQwNDE2MjQsImV4cCI6MjA1OTYxNzYyNH0.1Pdrk8G9UjzTBdE5w__5led6LjeXIdN_8g5mDLIQnIg";
const API_URL = "https://dxwpncxfauzspnqwwbxj.supabase.co/functions/v1/guestbook";

async function fetchEntries() {
  const res = await fetch(API_URL, {
    headers: {
      "Authorization": `Bearer ${API_KEY}`
    }
  });

  const data = await res.json();
  const container = document.getElementById("entries");
  container.innerHTML = "";

  if (!Array.isArray(data)) {
    container.innerHTML = `<p class="error">불러오기에 실패했습니다: ${sanitize(data.error || "Unknown error")}</p>`;
    return;
  }

  data.forEach(entry => {
    const div = document.createElement("div");
    div.className = "guestbook-entry";
    div.innerHTML = `
      <p>${sanitize(entry.message)}</p>
      <div class="meta">${sanitize(entry.name)} • ${new Date(entry.created_at).toLocaleString()}</div>
    `;
    container.appendChild(div);
  });
}

function sanitize(str) {
  const temp = document.createElement("div");
  temp.textContent = str;
  return temp.innerHTML;
}

document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("guestbook-form");
  const status = document.getElementById("form-status");

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    const name = document.getElementById("name").value.trim();
    const message = document.getElementById("message").value.trim();

    if (!name || !message) {
      status.textContent = "이름과 메시지를 모두 입력해주세요.";
      return;
    }

    const res = await fetch(API_URL, {
    method: "POST",
    headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${API_KEY}`
    },
    body: JSON.stringify({ name, message })
    });

    if (res.ok) {
      status.textContent = "등록되었습니다.";
      form.reset();
      fetchEntries();
    } else {
      const err = await res.json();
      status.textContent = `오류: ${err.error || "등록 실패"}`;
    }
  });

  fetchEntries();
});
