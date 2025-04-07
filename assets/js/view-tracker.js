(async () => {
  const slug = location.pathname;

  console.log("Tracking slug:", slug);

  await fetch("https://dxwpncxfauzspnqwwbxj.supabase.co/rest/v1/rpc/safe_increment_view", {
    method: "POST",
    headers: {
      apikey: "your-anon-key",
      Authorization: "Bearer your-anon-key",
      "Content-Type": "application/json",
      "Prefer": "params=single-object"  // ⬅️ 중요! 이걸 꼭 추가!
    },
    body: JSON.stringify({ slug: slug })
  });
})();
