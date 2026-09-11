-- BWP Smart Gate — ตารางผู้มาติดต่อ (แยกจากก้อน JSON เดิม)
-- รันครั้งเดียวใน Supabase SQL Editor (โปรเจกต์ cpvlchkqazsdsiviajqg)

create table if not exists public.smartgate_visitors (
  id          bigint primary key,              -- ใช้ id เดิมของระบบ (timestamp)
  name        text not null,
  company     text,
  phone       text,
  dept        text not null,                   -- แผนกที่ติดต่อ
  purpose     text,
  photos      jsonb not null default '[]'::jsonb,  -- รูปถ่าย (base64) เก็บแยกรายคน
  visit_date  text not null,                   -- วันที่แบบไทย เช่น "11 ก.ย. 2569"
  day_key     date not null,                   -- วันที่จริงไว้เรียง/กรอง
  time_in     text,
  time_out    text,
  status      text not null default 'กำลังติดต่อ',
  approved_by text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists smartgate_visitors_day_idx    on public.smartgate_visitors(day_key desc, id desc);
create index if not exists smartgate_visitors_status_idx on public.smartgate_visitors(status);
create index if not exists smartgate_visitors_dept_idx   on public.smartgate_visitors(dept, day_key desc);

alter table public.smartgate_visitors enable row level security;

drop policy if exists "visitors read"   on public.smartgate_visitors;
drop policy if exists "visitors insert" on public.smartgate_visitors;
drop policy if exists "visitors update" on public.smartgate_visitors;
drop policy if exists "visitors delete" on public.smartgate_visitors;

create policy "visitors read"   on public.smartgate_visitors for select using (true);
create policy "visitors insert" on public.smartgate_visitors for insert with check (true);
create policy "visitors update" on public.smartgate_visitors for update using (true);
create policy "visitors delete" on public.smartgate_visitors for delete using (true);
