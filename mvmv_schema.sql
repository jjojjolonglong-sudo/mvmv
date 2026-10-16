-- MVMV schema (Supabase SQL editor에서 한 번 실행). 다른 앱 테이블은 건드리지 않음.
create or replace function mvmv_touch() returns trigger language plpgsql as $$ begin new.updated_at=now(); return new; end $$;
create table if not exists mvmv_movie(id uuid primary key,user_id uuid default auth.uid(),name text not null,poster text,c1 text,c2 text,c3 text,sort text,genre text,date date,runtime int,countdown boolean default false,platform text,star numeric default 0,review text,created_at timestamptz default now(),updated_at timestamptz default now());
create table if not exists mvmv_episode(id uuid primary key,user_id uuid default auth.uid(),movie uuid references mvmv_movie(id) on delete cascade,name text,date date,runtime int,review text,created_at timestamptz default now(),updated_at timestamptz default now());
create table if not exists mvmv_people(id uuid primary key,user_id uuid default auth.uid(),name text not null,sort text[] default '{}',nation text,thumb text,birth date,death date,memo text,created_at timestamptz default now(),updated_at timestamptz default now());
create table if not exists mvmv_movie_people(id uuid primary key,user_id uuid default auth.uid(),movie uuid references mvmv_movie(id) on delete cascade,people uuid references mvmv_people(id) on delete cascade,sort text,role text,thumb text,created_at timestamptz default now(),updated_at timestamptz default now());
create table if not exists mvmv_scene(id uuid primary key,user_id uuid default auth.uid(),movie uuid references mvmv_movie(id) on delete cascade,episode uuid references mvmv_episode(id) on delete set null,actor uuid[] default '{}',time_input int,image text,local text,line text,memo text,ord int,created_at timestamptz default now(),updated_at timestamptz default now());
do $$ declare t text; begin foreach t in array array['mvmv_movie','mvmv_episode','mvmv_people','mvmv_movie_people','mvmv_scene'] loop
 execute format('alter table %I enable row level security',t);
 execute format('drop policy if exists mine on %I',t);
 execute format('create policy mine on %I for all using (user_id=auth.uid()) with check (user_id=auth.uid())',t);
 execute format('drop trigger if exists touch on %I',t);
 execute format('create trigger touch before update on %I for each row execute function mvmv_touch()',t);
end loop; end $$;
