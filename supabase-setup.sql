-- BWP Smart Gate — รันครั้งเดียวใน Supabase SQL Editor
-- (Dashboard → โปรเจกต์ cpvlchkqazsdsiviajqg → SQL Editor → New query → วางทั้งหมด → Run)

create table if not exists public.smartgate_store (
  key text primary key,
  data jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.smartgate_store enable row level security;

-- เดโม่: เปิดให้ทุกคนที่มี publishable key อ่าน/เขียนได้
-- (ระบบจริงควรเปลี่ยนเป็น auth + policy ตามบทบาท)
drop policy if exists "smartgate read" on public.smartgate_store;
create policy "smartgate read" on public.smartgate_store for select using (true);

drop policy if exists "smartgate insert" on public.smartgate_store;
create policy "smartgate insert" on public.smartgate_store for insert with check (true);

drop policy if exists "smartgate update" on public.smartgate_store;
create policy "smartgate update" on public.smartgate_store for update using (true);
