-- BWP Smart Gate — ตารางเก็บประวัติเข้า-ออกถาวร
-- รันครั้งเดียวใน Supabase SQL Editor (โปรเจกต์ cpvlchkqazsdsiviajqg)

create table if not exists public.smartgate_records (
  id         bigint generated always as identity primary key,
  emp_code   text not null,
  emp_name   text,
  dept       text,
  work_date  text not null,          -- วันที่แบบไทย เช่น "28 ส.ค. 2569"
  day_key    date  not null,         -- วันที่จริงไว้เรียง/กรอง
  out_time   text,                   -- เวลาออก HH:MM
  in_time    text,                   -- เวลากลับเข้า HH:MM
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists smartgate_records_day_idx on public.smartgate_records(day_key desc, id desc);
create index if not exists smartgate_records_emp_idx on public.smartgate_records(emp_code, day_key desc);

alter table public.smartgate_records enable row level security;

drop policy if exists "records read"   on public.smartgate_records;
drop policy if exists "records insert" on public.smartgate_records;
drop policy if exists "records update" on public.smartgate_records;
drop policy if exists "records delete" on public.smartgate_records;

create policy "records read"   on public.smartgate_records for select using (true);
create policy "records insert" on public.smartgate_records for insert with check (true);
create policy "records update" on public.smartgate_records for update using (true);
create policy "records delete" on public.smartgate_records for delete using (true);
