-- Create table
create table if not exists public.views (
  slug text not null,
  viewed_at date not null default current_date,
  count int not null default 1,
  updated_at timestamptz not null default now(),
  primary key (slug, viewed_at)
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

create table views_limiter_users (
  user_id uuid,
  key text,               -- 예: slug 이름 or endpoint 구분자
  ts text,                -- 시간 단위로 제한: 예) '2025-04-08' or '2025-04-08T14:00'
  count integer not null,
  updated_at timestamptz default now(),
  primary key (user_id, key, ts)
);

-- 기본적으로 차단
alter table views_limiter_users enable row level security;

create table views_limiter_ips (
  ip text,
  date text,              -- YYYY-MM-DD
  method text,            -- 'GET', 'POST', 'OPTIONS' 등
  count integer not null default 1,
  updated_at timestamptz default now(),
  primary key (ip, date, method)
);

alter table views_limiter_ips enable row level security;