import { serve } from "https://deno.land/std/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const ALLOWED_ORIGINS = [
  "https://devchan64.github.io",
  // "http://localhost:4000"
];

const corsHeaders = {
  "Access-Control-Allow-Origin": ALLOWED_ORIGINS[0],
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type"
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const referer = req.headers.get("referer") || "";
  const origin = req.headers.get("origin") || "";
  const isAllowed = ALLOWED_ORIGINS.some(o =>
    referer.startsWith(o) || origin.startsWith(o)
  );

  if (!isAllowed) {
    console.error("Blocked by referer/origin", { referer, origin });
    return new Response("Forbidden", { status: 403, headers: corsHeaders });
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
  );

  const url = new URL(req.url);

  if (req.method === "GET") {
    const rawDays = url.searchParams.get("days");
    const days = rawDays === null ? 30 : parseInt(rawDays, 10);

    if (isNaN(days) || days < 1 || days > 365) {
      return new Response(JSON.stringify({ error: "Invalid days parameter" }), {
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
      .gte("viewed_at", fromDateStr);

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

  // POST: slug 수신 후 count 증가
  try {
    const { slug: rawSlug } = await req.json();
    if (!rawSlug || typeof rawSlug !== "string") {
      return new Response(JSON.stringify({ error: "Invalid slug" }), {
        status: 400,
        headers: corsHeaders
      });
    }

    const slug = rawSlug.replace(/^\/en(?=\/)/, "");
    const today = new Date().toISOString().slice(0, 10);

    // 1. 현재 카운트 확인
    const { data: existing, error: readError } = await supabase
      .from("views")
      .select("count")
      .eq("slug", slug)
      .eq("viewed_at", today)
      .maybeSingle();

    if (readError) {
      console.error("Read error", readError);
      return new Response(JSON.stringify({ error: readError }), {
        status: 500,
        headers: corsHeaders
      });
    }

    // 2. count 갱신 또는 신규 insert
    const { error: writeError } = await supabase
      .from("views")
      .upsert({
        slug,
        viewed_at: today,
        count: existing ? existing.count + 1 : 1,
        updated_at: new Date().toISOString()
      }, {
        onConflict: ['slug', 'viewed_at']
      });

    if (writeError) {
      console.error("Write error", writeError);
      return new Response(JSON.stringify({ error: writeError }), {
        status: 500,
        headers: corsHeaders
      });
    }

    return new Response(JSON.stringify({ ok: true }), {
      headers: { "Content-Type": "application/json", ...corsHeaders }
    });
  } catch (e) {
    console.error("Unhandled error", e);
    return new Response(JSON.stringify({ error: "Invalid request" }), {
      status: 400,
      headers: corsHeaders
    });
  }
});
