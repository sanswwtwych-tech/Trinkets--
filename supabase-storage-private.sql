-- Trinkets Cloud: bucket PRIVADO + RLS do Storage
-- Execute no SQL Editor do Supabase.

insert into storage.buckets (id, name, public)
values ('trinkets-files', 'trinkets-files', false)
on conflict (id) do update set public = false;

-- Cada arquivo criado pelo Trinkets fica em:
-- auth.uid()/[pasta opcional]/arquivo
-- As políticas abaixo impedem que um usuário acesse o prefixo de outro usuário.

drop policy if exists "trinkets users can view own files" on storage.objects;
create policy "trinkets users can view own files"
on storage.objects
for select
to authenticated
using (
  bucket_id = 'trinkets-files'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);

drop policy if exists "trinkets users can upload own files" on storage.objects;
create policy "trinkets users can upload own files"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'trinkets-files'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);

drop policy if exists "trinkets users can update own files" on storage.objects;
create policy "trinkets users can update own files"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'trinkets-files'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
)
with check (
  bucket_id = 'trinkets-files'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);

drop policy if exists "trinkets users can delete own files" on storage.objects;
create policy "trinkets users can delete own files"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'trinkets-files'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);
