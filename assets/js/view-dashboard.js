(() => {
  const API_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR4d3BuY3hmYXV6c3BucXd3YnhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQwNDE2MjQsImV4cCI6MjA1OTYxNzYyNH0.1Pdrk8G9UjzTBdE5w__5led6LjeXIdN_8g5mDLIQnIg";
  const API_URL = "https://dxwpncxfauzspnqwwbxj.supabase.co/functions/v1/safe-increment-view";
  const MAX_ITEMS = 10;
  const DAYS = 30;

  const chartCanvas = document.getElementById("views-chart");
  const container = document.getElementById("popular-posts");

  const trimLabel = (text, max = 50) =>
    text.length > max ? text.slice(0, max) + "…" : text;
  const inferTitle = (slug) => slug;

  const getColors = (count) => {
    const base = [
      "rgba(255, 99, 132, 0.6)",
      "rgba(54, 162, 235, 0.6)",
      "rgba(255, 206, 86, 0.6)",
      "rgba(75, 192, 192, 0.6)",
      "rgba(153, 102, 255, 0.6)",
      "rgba(255, 159, 64, 0.6)",
    ];
    return Array.from({ length: count }, (_, i) => base[i % base.length]);
  };

  const fetchPostIndex = async () => {
    const isEnglish = location.pathname.startsWith("/en/");
    const path = isEnglish ? "/en/posts.json" : "/posts.json";


    const posts = await fetch(path).then((res) => res.json());
    const slugToTitle = {};

    posts.forEach((post) => {
      if (isEnglish) {
        slugToTitle[post.url.replace("/en/", "/")] = post.title;
      } else {
        slugToTitle[post.url] = post.title;
      }
    });

    return slugToTitle;
  };

  const fetchViewCounts = async () => {
    const res = await fetch(`${API_URL}?days=${DAYS}&limit=${MAX_ITEMS}`, {
      method: "GET",
      headers: {
        "Authorization": `Bearer ${API_KEY}`
      }
    });
    return res.json();
  };

  const render = async () => {
    container.innerHTML = `<p class="loading">Loading...</p>`;

    try {
      const [slugToTitle, views] = await Promise.all([
        fetchPostIndex(),
        fetchViewCounts(),
      ]);

      // 슬러그 필터링: post/로 시작하는 것만
      const dateSlugRegex = /^\/\d{4}\/\d{2}\/\d{2}\//;
      const filteredViews = views.filter(item =>
        dateSlugRegex.test(item.slug)
      );

      if (!filteredViews.length) {
        container.innerHTML = "<p class='error'>No view records found.</p>";
        return;
      }

      const isEnglish = location.pathname.startsWith("/en/");

      const labels = [];
      const counts = [];
      const listItems = filteredViews.map((item) => {
        const url = isEnglish ? "/en" + item.slug : item.slug;
        const title = slugToTitle[url] ?? inferTitle(url);
        const label = trimLabel(title);
        labels.push(label);
        counts.push(item.count);

        return `
          <li>
            <a href="${url}" title="${title}">${label}</a>
            <span class="count">${item.count} views</span>
          </li>`;
      });

      container.innerHTML = `<ul>${listItems.join("")}</ul>`;

      const backgroundColor = getColors(counts.length);
      const borderColor = backgroundColor.map((c) => c.replace("0.6", "1"));

      new Chart(chartCanvas, {
        type: "bar",
        data: {
          labels,
          datasets: [
            {
              label: `Page Views (Last ${DAYS} Days)`,
              data: counts,
              backgroundColor,
              borderColor,
              borderWidth: 1,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          indexAxis: "y",
          scales: {
            x: {
              beginAtZero: true,
              ticks: { stepSize: 1 },
            },
            y: {
              ticks: {
                autoSkip: false,
                font: { size: 12 },
              },
            },
          },
          plugins: {
            legend: { display: false },
          },
        },
      });
    } catch (err) {
      container.innerHTML = "<p class='error'>Failed to load data.</p>";
      console.error("Dashboard error:", err);
    }
  };

  render();
})();
