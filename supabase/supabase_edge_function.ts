import { serve } from "https://deno.land/std/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// CORS 허용 도메인
const ALLOWED_ORIGINS = [
  "https://devchan64.github.io",
  // "http://localhost:4000"
];

const corsHeaders = {
  "Access-Control-Allow-Origin": ALLOWED_ORIGINS[0],
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type"
};

// 공통 Rate Limit 함수 (IP + method 기준)
async function limitRequest(
  supabase: ReturnType<typeof createClient>,
  ip: string,
  method: string,
  max: number
): Promise<boolean> {
  const today = new Date().toISOString().slice(0, 10);

  const { data, error } = await supabase
    .from("views_limiter_ips")
    .select("count")
    .eq("ip", ip)
    .eq("date", today)
    .eq("method", method)
    .maybeSingle();

  if (error) {
    console.error(`Rate limit read error [${method}]`, error);
    return true; // fail-safe
  }

  const count = data?.count ?? 0;
  if (count >= max) return true;

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

function createSupabaseClient() {
  return createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
  );
}

// 서버 시작
serve(async (req) => {

  const method = req.method;
  const today = new Date().toISOString().slice(0, 10);
  const ip = req.headers.get("x-forwarded-for") ?? "unknown";
  const supabase = createSupabaseClient();

  // 공통 Rate Limit 적용 (GET/POST)
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

  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  // Referer / Origin 체크
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

  if (method === "GET") {
    const rawDays = url.searchParams.get("days");
    const rawLimit = url.searchParams.get("limit");

    const days = rawDays === null ? 30 : parseInt(rawDays, 10);
    const limit = rawLimit === null ? 10 : parseInt(rawLimit, 10);

    if (isNaN(days) || days < 1 || days > 365 || isNaN(limit) || limit < 1 || limit > 100) {
      return new Response(JSON.stringify({ error: "Invalid query parameters" }), {
        status: 400,
        headers: corsHeaders
      });
    }

    const fromDate = new Date();
    fromDate.setDate(fromDate.getDate() - days);
    const fromDateStr = fromDate.toISOString().slice(0, 10);

    const { data, error } = await supabase
      .from("views")
      .select("slug, viewed_at, count")
      .gte("viewed_at", fromDateStr)
      .order("count", { ascending: false }) // 💡 조회수 기준 정렬
      .limit(limit);                        // 💡 limit 적용

    if (error) {
      console.error("GET failed", error);
      return new Response(JSON.stringify({ error }), {
        status: 500,
        headers: corsHeaders
      });
    }

    return new Response(JSON.stringify(data), {
      headers: { "Content-Type": "application/json", ...corsHeaders }
    });
  }


  if (method === "POST") {
    const jwt = req.headers.get("authorization")?.replace("Bearer ", "");
    if (!jwt) {
      return new Response("Unauthorized", { status: 401, headers: corsHeaders });
    }

    const payload = JSON.parse(atob(jwt.split(".")[1]));
    const userId = payload.sub;

    try {
      const { slug: rawSlug } = await req.json();
      if (!rawSlug || typeof rawSlug !== "string") {
        return new Response(JSON.stringify({ error: "Invalid slug" }), {
          status: 400,
          headers: corsHeaders
        });
      }

      const slug = rawSlug.replace(/^\/en(?=\/)/, "");

      // 사용자 슬러그 기준 리밋 (10회/일)
      const { data: userLimit, error: userLimitErr } = await supabase
        .from("views_limiter_users")
        .select("count")
        .eq("user_id", userId)
        .eq("key", slug)
        .eq("ts", today)
        .maybeSingle();

      if (userLimitErr) throw userLimitErr;

      const userCount = userLimit?.count ?? 0;
      if (userCount >= 10) {
        return new Response("Too Many Requests (user)", {
          status: 429,
          headers: corsHeaders
        });
      }

      await supabase
        .from("views_limiter_users")
        .upsert({
          user_id: userId,
          key: slug,
          ts: today,
          count: userCount + 1,
          updated_at: new Date().toISOString()
        }, {
          onConflict: ['user_id', 'key', 'ts']
        });

      // slug별 조회수 증가
      const { data: existing, error: readError } = await supabase
        .from("views")
        .select("count")
        .eq("slug", slug)
        .eq("viewed_at", today)
        .maybeSingle();

      if (readError) throw readError;

      await supabase
        .from("views")
        .upsert({
          slug,
          viewed_at: today,
          count: existing ? existing.count + 1 : 1,
          updated_at: new Date().toISOString()
        }, {
          onConflict: ['slug', 'viewed_at']
        });

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

  return new Response("Not Found", { status: 404, headers: corsHeaders });
});
