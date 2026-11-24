-- À exécuter une seule fois : Supabase → SQL Editor → New query → Run.
-- Une seule ligne par utilisateur ; chacun ne peut lire/écrire que SA ligne (Row Level Security).

create table if not exists public.budgets (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  constraint budgets_data_size check (pg_column_size(data) < 300000)  -- limite anti-abus (~300 Ko)
);

alter table public.budgets enable row level security;
alter table public.budgets force row level security;

drop policy if exists "budgets_select_own" on public.budgets;
drop policy if exists "budgets_insert_own" on public.budgets;
drop policy if exists "budgets_update_own" on public.budgets;
drop policy if exists "budgets_delete_own" on public.budgets;

create policy "budgets_select_own" on public.budgets for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "budgets_insert_own" on public.budgets for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "budgets_update_own" on public.budgets for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "budgets_delete_own" on public.budgets for delete to authenticated
  using ((select auth.uid()) = user_id);

-- Aucun accès pour les visiteurs non connectés.
revoke all on public.budgets from anon;
grant select, insert, update, delete on public.budgets to authenticated;
