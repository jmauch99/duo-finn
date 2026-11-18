-- Duo Finn · banco no Supabase. Cole tudo no SQL Editor e clique em Run.
-- ANTES: troque os dois e-mails abaixo pelos e-mails reais de vocês.

create table if not exists public.membros (email text primary key);
insert into public.membros (email) values
  ('jmauch99@gmail.com'),
  ('bruna.bisposouza@uni9.edu.br')
on conflict do nothing;

-- uma linha guarda o estado inteiro do app; "rev" evita que um sobrescreva o outro sem perceber
create table if not exists public.app_state (
  id         text primary key,
  data       jsonb       not null,
  rev        bigint      not null default 1,
  updated_by text,
  updated_at timestamptz not null default now()
);

-- histórico: guarda uma cópia anterior no máximo a cada 6 horas e apaga as de mais de 60 dias
create table if not exists public.app_state_hist (
  n        bigserial primary key,
  id       text not null,
  rev      bigint not null,
  data     jsonb not null,
  saved_at timestamptz not null default now()
);

create or replace function public.guarda_historico() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if not exists (select 1 from app_state_hist h where h.id = old.id and h.saved_at > now() - interval '6 hours') then
    insert into app_state_hist (id, rev, data) values (old.id, old.rev, old.data);
  end if;
  delete from app_state_hist where saved_at < now() - interval '60 days';
  return new;
end $$;

drop trigger if exists trg_hist on public.app_state;
create trigger trg_hist before update on public.app_state
  for each row execute function public.guarda_historico();

-- segurança: só quem está em "membros" lê e grava
alter table public.membros        enable row level security;
alter table public.app_state      enable row level security;
alter table public.app_state_hist enable row level security;

drop policy if exists membros_le_proprio on public.membros;
create policy membros_le_proprio on public.membros for select to authenticated
  using (email = (auth.jwt() ->> 'email'));

drop policy if exists app_state_membros on public.app_state;
create policy app_state_membros on public.app_state for all to authenticated
  using      (exists (select 1 from public.membros m where m.email = (auth.jwt() ->> 'email')))
  with check (exists (select 1 from public.membros m where m.email = (auth.jwt() ->> 'email')));

-- o histórico só é lido pelo painel do Supabase (nenhuma policy = ninguém pelo app)
