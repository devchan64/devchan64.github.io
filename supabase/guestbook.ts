import { serve } from "https://deno.land/std/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { limitRequest } from "./limitRequest.ts";
import { getClientIp } from "./getClientIp.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "https://devchan64.github.io",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Content-Type": "application/json",
};

function createSupabaseClient() {
  return createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
  );
}

function isValidInput(name: string, message: string): boolean {
  return name.length <= 50 && message.length <= 100;
}

serve(async (req) => {
  const method = req.method;
  const ip = getClientIp(req);
  const supabase = createSupabaseClient();

  // Rate limit check
  const methodLimits = { GET: 300, POST: 10, OPTIONS: 500 };
  const limit = methodLimits[method as keyof typeof methodLimits];
  if (limit) {
    const limited = await limitRequest(supabase, ip, method, limit);
    if (limited) {
      return new Response(JSON.stringify({ error: "Too Many Requests" }), {
        status: 429,
        headers: corsHeaders,
      });
    }
  }

  // OPTIONS preflight
  if (method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  // GET: recent messages
  if (method === "GET") {
    const { data, error } = await supabase
      .from("guestbook_entries")
      .select("id, name, message, created_at")
      .eq("is_public", true)
      .order("created_at", { ascending: false })
      .limit(20);

    if (error) {
      return new Response(JSON.stringify({ error: error.message }), {
        status: 500,
        headers: corsHeaders,
      });
    }

    return new Response(JSON.stringify(data), {
      status: 200,
      headers: corsHeaders,
    });
  }

  // POST: write new message
  if (method === "POST") {
    try {
      const { name, message } = await req.json();

      if (!name || !message || !isValidInput(name, message)) {
        return new Response(JSON.stringify({ error: "Invalid input" }), {
          status: 400,
          headers: corsHeaders,
        });
      }

      const { error } = await supabase.from("guestbook_entries").insert([
        {
          name,
          message,
          created_at: new Date().toISOString(),
          ip,
        },
      ]);

      if (error) {
        return new Response(JSON.stringify({ error: error.message }), {
          status: 500,
          headers: corsHeaders,
        });
      }

      return new Response(JSON.stringify({ message: "Entry added" }), {
        status: 200,
        headers: corsHeaders,
      });
    } catch (err) {
      return new Response(JSON.stringify({ error: "Server error" }), {
        status: 500,
        headers: corsHeaders,
      });
    }
  }

  return new Response(JSON.stringify({ error: "Method Not Allowed" }), {
    status: 405,
    headers: corsHeaders,
  });
});
