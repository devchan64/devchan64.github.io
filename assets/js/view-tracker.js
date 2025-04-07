(async () => {
  await fetch("https://dxwpncxfauzspnqwwbxj.supabase.co/functions/v1/safe-increment-view", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ slug: location.pathname })
  });  
})();
