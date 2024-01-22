with first_day as (
    select player_id, event_date,
    row_number() over (partition by player_id order by event_date)rn
    from activity
),
data as (
    select count(distinct fd.player_id) consecutive
    from first_day fd
    inner join activity a2
    on fd.player_id = a2.player_id
    and date_add(fd.event_date, interval 1 day) = a2.event_date
    where rn=1
)
select round(
    consecutive/
    (select count(distinct player_id) from activity),
2) fraction
from data