(async () => {
  const slug = location.pathname;
  console.log(slug)
  await fetch("https://dxwpncxfauzspnqwwbxj.supabase.co/functions/v1/safe-increment-view", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      slug: slug
    })
  });
})();
