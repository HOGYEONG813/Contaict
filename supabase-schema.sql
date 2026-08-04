-- Contact: Supabase SQL Editor에서 한 번 실행하세요.
-- 비밀번호는 절대 이 테이블에 저장하지 않습니다.
-- 회원가입/로그인은 Supabase Auth가 auth.users 테이블에서 처리합니다.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique not null check (char_length(username) between 4 and 20),
  role text not null default 'user' check (role in ('user', 'admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  author_id uuid not null references public.profiles(id) on delete cascade,
  type text not null check (type in ('freight', 'community')),
  user_role text check (user_role in ('carrier', 'shipper')),
  category text,
  title text not null check (char_length(title) between 1 and 80),
  content text not null check (char_length(content) between 1 and 800),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.direct_messages (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.posts(id) on delete cascade,
  sender_id uuid not null references public.profiles(id) on delete cascade,
  recipient_id uuid not null references public.profiles(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 500),
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.posts enable row level security;
alter table public.direct_messages enable row level security;

create policy "profiles are visible" on public.profiles for select using (true);
create policy "users create own profile" on public.profiles for insert with check (auth.uid() = id);
create policy "users edit own profile" on public.profiles for update using (auth.uid() = id);

create policy "posts are visible" on public.posts for select using (true);
create policy "signed in users create posts" on public.posts for insert with check (auth.uid() = author_id);
create policy "authors edit posts" on public.posts for update using (auth.uid() = author_id);
create policy "authors delete posts" on public.posts for delete using (auth.uid() = author_id);

create policy "participants see messages" on public.direct_messages for select using (auth.uid() = sender_id or auth.uid() = recipient_id);
create policy "sender creates message" on public.direct_messages for insert with check (auth.uid() = sender_id);

-- 관리자 권한: Supabase Dashboard에서 관리자 계정의 profiles.role을 admin으로 변경하세요.
create policy "admins delete any post" on public.posts for delete using (
  exists (select 1 from public.profiles where id = auth.uid() and role = 'admin')
);
