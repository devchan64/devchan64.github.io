(async () => {
  const slug = location.pathname;
  console.log(slug)
  await fetch("https://<your-project>.functions.supabase.co/safe-increment-view", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      slug: slug
    })
  });
})();
