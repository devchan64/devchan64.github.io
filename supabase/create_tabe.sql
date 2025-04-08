-- Create table
create table if not exists public.views (
  slug text primary key,
  count int not null default 1,
  updated_at timestamptz not null default now()
);

-- Enforce RLS
alter table public.views enable row level security;

-- READ ONLY: allow anonymous users to read views
create policy "Allow anon to read views"
  on public.views
  for select
  to anon
  using (true);

-- FULL ACCESS: allow service role to insert/update/delete
create policy "Allow service role full access"
  on public.views
  for all
  to service_role
  using (true)
  with check (true);

-- (Required for upsert)
alter table public.views add constraint views_slug_unique unique (slug);
