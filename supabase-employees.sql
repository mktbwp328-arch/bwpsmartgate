-- BWP Smart Gate — เก็บรายชื่อพนักงานเป็นตารางจริง (หนึ่งแถวต่อหนึ่งคน)
-- เดิมเก็บรวมเป็นก้อนเดียว พอมีคนตั้ง PIN หรือแก้ข้อมูลทีเดียว ทุกเครื่องต้องโหลดใหม่ทั้งก้อน (~36 KB)
-- เปลี่ยนเป็นตารางแล้ว จะโหลดเฉพาะแถวที่เปลี่ยน (~0.3 KB)
-- รันครั้งเดียวใน Supabase SQL Editor (โปรเจกต์ cpvlchkqazsdsiviajqg)

create table if not exists public.smartgate_employees (
  code       text primary key,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);

create index if not exists smartgate_employees_updated_idx
  on public.smartgate_employees (updated_at);

-- เวลาแก้ไขใช้นาฬิกาของเซิร์ฟเวอร์เสมอ (นาฬิกามือถือแต่ละเครื่องไม่ตรงกัน)
create or replace function public.smartgate_employees_touch()
returns trigger language plpgsql as $$
begin new.updated_at := now(); return new; end $$;

drop trigger if exists smartgate_employees_touch on public.smartgate_employees;
create trigger smartgate_employees_touch
  before insert or update on public.smartgate_employees
  for each row execute function public.smartgate_employees_touch();

alter table public.smartgate_employees enable row level security;

drop policy if exists "smartgate_employees_all" on public.smartgate_employees;
create policy "smartgate_employees_all" on public.smartgate_employees
  for all using (true) with check (true);
