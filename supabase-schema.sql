-- Trinkets: execute no SQL Editor do Supabase
create table if not exists public.file_metadata (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 name text not null, path text not null unique, size bigint not null default 0,
 mime_type text not null default 'application/octet-stream', folder text not null default '',
 favorite boolean not null default false, trashed boolean not null default false,
 created_at timestamptz not null default now()
);
alter table public.file_metadata enable row level security;
create policy "users can view own files" on public.file_metadata for select using (auth.uid()=user_id);
create policy "users can insert own files" on public.file_metadata for insert with check (auth.uid()=user_id);
create policy "users can update own files" on public.file_metadata for update using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "users can delete own files" on public.file_metadata for delete using (auth.uid()=user_id);
create table if not exists public.folders (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 name text not null,
 created_at timestamptz not null default now(),
 unique(user_id,name)
);
alter table public.folders enable row level security;
create policy "users can view own folders" on public.folders for select using (auth.uid()=user_id);
create policy "users can create own folders" on public.folders for insert with check (auth.uid()=user_id);
create policy "users can update own folders" on public.folders for update using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "users can delete own folders" on public.folders for delete using (auth.uid()=user_id);
-- No Storage: crie manualmente um bucket PRIVADO chamado trinkets-files.
-- Depois aplique políticas de Storage para permitir acesso somente ao prefixo auth.uid()/.
