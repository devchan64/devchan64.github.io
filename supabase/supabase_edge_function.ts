import { serve } from "https://deno.land/std/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "https://devchan64.github.io",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type"
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { slug } = await req.json();

    if (!slug || typeof slug !== "string") {
      return new Response(JSON.stringify({ error: "Invalid slug" }), {
        status: 400,
        headers: corsHeaders
      });
    }

    const referer = req.headers.get("referer") || "";
    const allowedOrigin = "https://devchan64.github.io";
    if (!referer.startsWith(allowedOrigin)) {
      console.error("Blocked referer:", referer);
      return new Response("Forbidden", { status: 403, headers: corsHeaders });
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    const { data, error } = await supabase
      .from("views")
      .upsert({ slug, count: 1, updated_at: new Date().toISOString() }, { onConflict: "slug" })
      .select()
      .single();

    if (error) {
      return new Response(JSON.stringify({ error }), {
        status: 500,
        headers: corsHeaders
      });
    }

    return new Response(JSON.stringify({ ok: true, view: data }), {
      headers: {
        "Content-Type": "application/json",
        ...corsHeaders
      }
    });

  } catch (e) {
    console.error("Request error:", e);
    return new Response(JSON.stringify({ error: "Invalid request" }), {
      status: 400,
      headers: corsHeaders
    });
  }
});