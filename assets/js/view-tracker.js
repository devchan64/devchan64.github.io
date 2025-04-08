(async () => {
  const slug = location.pathname;
  console.log(slug);
  await fetch("https://dxwpncxfauzspnqwwbxj.supabase.co/functions/v1/safe-increment-view", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR4d3BuY3hmYXV6c3BucXd3YnhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQwNDE2MjQsImV4cCI6MjA1OTYxNzYyNH0.1Pdrk8G9UjzTBdE5w__5led6LjeXIdN_8g5mDLIQnIg"
    },
    body: JSON.stringify({
      slug
    })
  });
})();