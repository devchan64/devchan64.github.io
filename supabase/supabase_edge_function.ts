// Deno 표준 HTTP 서버와 Supabase 클라이언트 가져오기
import { serve } from "https://deno.land/std/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// 허용된 CORS Origin 목록
const ALLOWED_ORIGINS = [
  "https://devchan64.github.io",
  // "http://localhost:4000"  // 로컬 테스트용
];

// CORS 헤더 설정
const corsHeaders = {
  "Access-Control-Allow-Origin": ALLOWED_ORIGINS[0],
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type"
};

// Supabase 클라이언트 생성 함수
function createSupabaseClient() {
  return createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
  );
}

// Rate Limit 처리 함수 (IP + method 기준, views_limiter_ips 테이블 사용)
async function limitRequest(
  supabase: ReturnType<typeof createClient>,
  ip: string,
  method: string,
  max: number
): Promise<boolean> {
  const today = new Date().toISOString().slice(0, 10);

  // 오늘 해당 IP가 method 요청한 횟수 조회
  const { data, error } = await supabase
    .from("views_limiter_ips")
    .select("count")
    .eq("ip", ip)
    .eq("date", today)
    .eq("method", method)
    .maybeSingle();

  if (error) {
    console.error(`Rate limit read error [${method}]`, error);
    return true; // 에러 발생 시 fail-safe로 차단
  }

  const count = data?.count ?? 0;
  if (count >= max) return true;

  // 요청 횟수 증가 (upsert)
  const { error: writeError } = await supabase
    .from("views_limiter_ips")
    .upsert({
      ip,
      date: today,
      method,
      count: count + 1,
      updated_at: new Date().toISOString()
    }, {
      onConflict: ['ip', 'date', 'method']
    });

  if (writeError) {
    console.error(`Rate limit write error [${method}]`, writeError);
    return true;
  }

  return false;
}

async function get(url: URL, supabase: ReturnType<typeof createClient>) {
  const rawDays = url.searchParams.get("days");
  const rawLimit = url.searchParams.get("limit");
  const days = Number(rawDays ?? 30);
  const limit = Number(rawLimit ?? 10);

  // 파라미터 유효성 검사
  if (isNaN(days) || days < 1 || days > 365 || isNaN(limit) || limit < 1 || limit > 100) {
    return new Response(JSON.stringify({
      error: "Invalid query parameters",
      days,
      limit
    }), {
      status: 400,
      headers: corsHeaders
    });
  }

  // 조회 기준 날짜 목록 생성
  const today = new Date();
  today.setUTCHours(0, 0, 0, 0);
  const dateList: string[] = [];
  for (let i = 0; i < days; i++) {
    const d = new Date(today);
    d.setUTCDate(today.getUTCDate() - i);
    dateList.push(d.toISOString().slice(0, 10));
  }

  const fromDateStr = dateList[dateList.length-1];

  // Supabase에서 조회 로그 조회
  const { data, error } = await supabase
    .from("views")
    .select("slug, viewed_at")
    .gte("viewed_at", fromDateStr);

  if (error) {
    console.error("GET failed", error);
    return new Response(JSON.stringify({
      error: error.message,
      details: error.details
    }), {
      status: 500,
      headers: corsHeaders
    });
  }

  const filtered_slugs = ["/", "/views/"];
  const countBySlug: Record<string, any> = {};
  const totalByDate = Object.fromEntries(dateList.map((d) => [d, 0]));

  for (const row of data ?? []){
    const { slug, viewed_at } = row;
    const dateStr = new Date(viewed_at).toISOString().slice(0, 10);
    
    if (totalByDate[dateStr] !== undefined) {
      totalByDate[dateStr] += 1;
    }
    if (filtered_slugs.includes(slug)) continue;
    if (!countBySlug[slug]) {
      countBySlug[slug] = {
        count: 0,
        counts_day: Object.fromEntries(dateList.map((d)=>[
            d,
            0
          ]))
      };
    }
    countBySlug[slug].count += 1;
    countBySlug[slug].counts_day[dateStr] += 1;
  }
  
  const bySlug = Object.entries(countBySlug).map(([slug, { count, counts_day }])=>({
      slug,
      count,
      counts_day: dateList.map((date)=>({
          date,
          count: counts_day[date]
        }))
    })).sort((a, b)=>b.count - a.count).slice(0, limit);
  const daily = dateList.map((date)=>({
      date,
      count: totalByDate[date]
    }));
  const total = daily.reduce((sum, entry)=>sum + entry.count, 0);

  return {
    by_slug: bySlug,
    total_by_date: {
      total,
      daily,
    },
  };
}

// 서버 시작
serve(async (req) => {
  const method = req.method;
  const ip =
    req.headers.get("cf-connecting-ip") ??
    req.headers.get("x-real-ip") ??
    req.headers.get("x-forwarded-for")?.split(",")[0].trim() ??
    req.headers.get("remote-addr") ?? "unknown";
  const supabase = createSupabaseClient();

  // 공통 Rate Limit 제한 (method별 최대 요청 수)
  const methodLimits = {
    GET: 300,
    POST: 100,
    OPTIONS: 500,
  };

  if (method in methodLimits) {
    const limited = await limitRequest(supabase, ip, method, methodLimits[method]);
    if (limited) {
      return new Response(`Too Many Requests (${method})`, {
        status: 429,
        headers: corsHeaders
      });
    }
  }

  // CORS 프리플라이트 요청 처리
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  // 허용된 origin/referer가 아니면 요청 차단
  const referer = req.headers.get("referer") || "";
  const origin = req.headers.get("origin") || "";
  const isAllowed = ALLOWED_ORIGINS.some(o =>
    referer.startsWith(o) || origin.startsWith(o)
  );
  if (!isAllowed) {
    console.error("Blocked by referer/origin", { referer, origin });
    return new Response("Forbidden", { status: 403, headers: corsHeaders });
  }

  const url = new URL(req.url);

  // POST: 슬러그 조회 기록 등록
  if (method === "POST") {
    try {
      const { slug: rawSlug } = await req.json();
      if (!rawSlug || typeof rawSlug !== "string") {
        return new Response(JSON.stringify({ error: "Invalid slug" }), {
          status: 400,
          headers: corsHeaders
        });
      }

      const slug = rawSlug.replace(/^\/en(?=\/)/, "");

      // views 테이블에 upsert (중복 방지: slug + viewed_at + ip)
      const { error: insertError } = await supabase
        .from("views")
        .upsert({
          slug,
          ip,
          created_at: new Date().toISOString()
        }, {
          onConflict: ['slug', 'viewed_at', 'ip']
        });

      if (insertError) {
        console.error("Insert failed", insertError);
        return new Response(JSON.stringify({ error: "Insert failed" }), {
          status: 500,
          headers: corsHeaders
        });
      }

      return new Response(JSON.stringify({ ok: true }), {
        headers: { "Content-Type": "application/json", ...corsHeaders }
      });

    } catch (e) {
      console.error("POST failed", e);
      return new Response(JSON.stringify({ error: "Unexpected error" }), {
        status: 500,
        headers: corsHeaders
      });
    }
  }

  // GET: 조회수 집계 조회 (JavaScript로 count 처리)
  if (method === "GET") {
    const result = await get(url, supabase);
    return new Response(JSON.stringify(result), {
      headers: { "Content-Type": "application/json", ...corsHeaders }
    });
  }  

  // 정의되지 않은 요청 처리
  return new Response("Not Found", { status: 404, headers: corsHeaders });
});
