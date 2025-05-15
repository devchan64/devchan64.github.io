-- 조회수 테이블 생성: 슬러그별 일간 조회수를 기록
create table views (
  id uuid primary key default gen_random_uuid(),     -- 고유 식별자 (PK)
  slug text not null,                                -- 페이지 식별자
  viewed_at date not null default current_date,      -- 조회 날짜 (날짜만)
  ip text not null,                                   -- IP 주소 (중복 방지용)
  created_at timestamptz default now(),              -- 요청 시간
  constraint views_unique_slug_date_ip unique (slug, viewed_at, ip)
);

-- RLS 활성화 (행 수준 보안)
alter table public.views enable row level security;

-- UPSERT를 위한 제약 조건 (슬러그 단일성 보장)
alter table public.views add constraint views_slug_unique unique (slug);

-- IP 단위 요청 제한 테이블
create table views_limiter_ips (
  ip text,                                            -- 클라이언트 IP
  date text,                                          -- 날짜 (YYYY-MM-DD)
  method text,                                        -- HTTP 메서드 ('GET', 'POST' 등)
  count integer not null default 1,                   -- 요청 횟수
  updated_at timestamptz default now(),               -- 마지막 업데이트 시각
  primary key (ip, date, method)
);

-- RLS 활성화 (행 수준 보안)
alter table views_limiter_ips enable row level security;

-- 오래된 데이터 삭제 쿼리 (30일 초과)
delete from public.views
where viewed_at < current_date - interval '30 days';

delete from public.views_limiter_ips
where date < to_char(current_date - interval '30 days', 'YYYY-MM-DD');


-- 1. 테이블 생성
create table if not exists public.guestbook_entries (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  message text not null,
  created_at timestamp with time zone default now(),
  ip text,
  is_public boolean default true
);

-- 2. 정렬 최적화를 위한 인덱스 (최근순 조회)
create index if not exists guestbook_created_at_idx
on public.guestbook_entries (created_at desc);

-- 3. Row Level Security 활성화
alter table public.guestbook_entries enable row level security;

-- 4. SELECT 정책: 누구나 읽을 수 있도록 허용 (단, 공개된 메시지만)
create policy "Allow read to all"
on public.guestbook_entries
for select
using (
  is_public = true
);

-- 5. INSERT 정책: 엣지 펑션(service_role)에서만 작성 허용
create policy "Allow insert from edge function only"
on public.guestbook_entries
for insert
with check (
  current_setting('request.jwt.claims', true)::json ->> 'role' = 'service_role'
);
