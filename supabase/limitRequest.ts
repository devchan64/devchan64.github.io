// supabase/functions/lib/limitRequest.ts
import { createClient } from "https://esm.sh/@supabase/supabase-js";

export async function limitRequest(
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
    return true;
  }

  const count = data?.count ?? 0;
  if (count >= max) return true;

  const { error: writeError } = await supabase
    .from("views_limiter_ips")
    .upsert(
      {
        ip,
        date: today,
        method,
        count: count + 1,
        updated_at: new Date().toISOString(),
      },
      { onConflict: ["ip", "date", "method"] }
    );

  if (writeError) {
    console.error(`Rate limit write error [${method}]`, writeError);
    return true;
  }

  return false;
}
