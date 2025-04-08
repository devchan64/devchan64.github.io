-- 조회수 테이블 생성: 슬러그별 일간 조회수를 기록
create table if not exists public.views (
  slug text not null,                                -- 페이지 식별자
  viewed_at date not null default current_date,      -- 조회 날짜
  count int not null default 1,                      -- 조회수
  updated_at timestamptz not null default now(),     -- 마지막 업데이트 시각
  primary key (slug, viewed_at)
);

-- RLS 활성화 (행 수준 보안)
alter table public.views enable row level security;

-- UPSERT를 위한 제약 조건 (슬러그 단일성 보장)
alter table public.views add constraint views_slug_unique unique (slug);

-- 사용자 단위 요청 제한 테이블
create table views_limiter_users (
  user_id uuid,                                       -- 사용자 식별자
  key text,                                           -- 제한 기준 키 (예: slug, endpoint 등)
  ts text,                                            -- 시간 단위 (예: '2025-04-08', '2025-04-08T14:00')
  count integer not null,                             -- 요청 횟수
  updated_at timestamptz default now(),               -- 마지막 업데이트 시각
  primary key (user_id, key, ts)
);

-- RLS 활성화 (행 수준 보안)
alter table views_limiter_users enable row level security;

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

delete from public.views_limiter_users
where ts < to_char(current_date - interval '30 days', 'YYYY-MM-DD');

delete from public.views_limiter_ips
where date < to_char(current_date - interval '30 days', 'YYYY-MM-DD');

