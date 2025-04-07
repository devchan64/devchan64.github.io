(async () => {
  const slug = location.pathname;

  console.log("Tracking slug:", slug);

  await fetch("https://dxwpncxfauzspnqwwbxj.supabase.co/rest/v1/rpc/safe_increment_view", {
    method: "POST",
    headers: {
      apikey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR4d3BuY3hmYXV6c3BucXd3YnhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQwNDE2MjQsImV4cCI6MjA1OTYxNzYyNH0.1Pdrk8G9UjzTBdE5w__5led6LjeXIdN_8g5mDLIQnIg",
      Authorization: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR4d3BuY3hmYXV6c3BucXd3YnhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQwNDE2MjQsImV4cCI6MjA1OTYxNzYyNH0.1Pdrk8G9UjzTBdE5w__5led6LjeXIdN_8g5mDLIQnIg",      
      "Content-Type": "application/json",
      "Prefer": "params=single-object"  // ⬅️ 중요! 이걸 꼭 추가!
    },
    body: JSON.stringify({ slug: slug })
  });
})();
