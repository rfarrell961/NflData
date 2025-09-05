
select g.week, g.season, g.game_date, g.game_id, pass_stats.pass_yards
from (select p2.game_id, sum(p2.yards_gained) as pass_yards
from play_participants pp
inner join players p 
	on p.player_id = pp.player_id
inner join plays p2
	on p2.play_id = pp.play_id
inner join games g
	on g.game_id = p2.game_id
where p.last_name = 'Allen'
and p.first_name = 'Joshua'
and pp.role = 'passer'
and p2.complete_pass = true
and g.regular_season = true
group by p2.game_id) as pass_stats
inner join games g
	on g.game_id = pass_stats.game_id
order by g.season asc, g.week asc;
