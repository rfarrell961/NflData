with qb_list as (
    select distinct player_id
    from rosters
    where position = 'QB'
)
select p.first_name, p.last_name, sum(pl.yards_gained) as career_yards
from play_participants pp
inner join plays pl
    on pl.play_id = pp.play_id
inner join games g
    on g.game_id = pl.game_id
inner join qb_list q
    on q.player_id = pp.player_id
inner join players p
    on p.player_id = pp.player_id
where g.regular_season = true
  and pl.complete_pass = true
  and pp.role = 'passer'
  and p.rookie_year >= 2002
group by p.player_id, p.first_name, p.last_name
order by career_yards desc;