-- This file documents the additional production hardening applied to the connected Supabase project.
-- The initial schema migration is already in the project. Re-run this file only on a fresh database after that schema.
create extension if not exists pg_trgm;
create schema if not exists extensions;
alter extension pg_trgm set schema extensions;

create or replace function public.get_public_stats() returns jsonb language sql stable security invoker set search_path=public,extensions as $$
select jsonb_build_object('reported',(select count(*) from public.items where status in ('active','resolved')),'found',(select count(*) from public.items where type='found' and status in ('active','resolved')),'lost',(select count(*) from public.items where type='lost' and status in ('active','resolved')),'returned',(select count(*) from public.items where status='resolved'),'districts',(select count(*) from public.districts));
$$;

create or replace function public.get_item_matches(target_id uuid, limit_count integer default 8) returns table(item_id uuid,score numeric,reasons jsonb) language sql stable security invoker set search_path=public,extensions as $$
with target as(select i.* from public.items i where i.id=target_id and i.status='active'), candidates as(select c.*,(case when c.category_id is not null and t.category_id=c.category_id then 38 else 0 end+case when c.district_id is not null and t.district_id=c.district_id then 28 else 0 end+case when t.event_date is not null and c.event_date is not null then greatest(0,20-least(20,abs(c.event_date-t.event_date))) else 0 end+case when c.location_text is not null and t.location_text is not null then least(8,similarity(lower(c.location_text),lower(t.location_text))*8) else 0 end+least(6,similarity(lower(c.title||' '||c.description),lower(t.title||' '||t.description))*6))::numeric raw_score from public.items c cross join target t where c.id<>t.id and c.status='active' and c.type<>t.type)
select c.id,round(least(99,greatest(1,c.raw_score)),0),to_jsonb(array_remove(ARRAY[case when c.category_id=(select category_id from target) then 'Same category' end,case when c.district_id=(select district_id from target) then 'Same district' end,case when (select event_date from target) is not null and c.event_date is not null and abs(c.event_date-(select event_date from target))<=7 then 'Close date' end,case when similarity(lower(c.title||' '||c.description),lower((select title||' '||description from target)))>0.35 then 'Similar details' end],null)) from candidates c where c.raw_score>=25 order by c.raw_score desc limit greatest(1,least(limit_count,25));
$$;

-- Storage buckets: item-images (public) and claim-proofs (private) are configured in Supabase.
-- Realtime: messages, notifications and matches are in supabase_realtime.
