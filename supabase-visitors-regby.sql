-- BWP Smart Gate — บันทึกว่า รปภ. คนไหนเป็นคนลงทะเบียนผู้มาติดต่อ
-- รันครั้งเดียวใน Supabase SQL Editor (โปรเจกต์ cpvlchkqazsdsiviajqg)

alter table public.smartgate_visitors add column if not exists registered_by      text;  -- ชื่อ รปภ.
alter table public.smartgate_visitors add column if not exists registered_by_code text;  -- รหัสพนักงาน รปภ.
