with d1 as (
    select name as results, count(*) as cnt,
    row_number() over (order by count(*) desc, name asc)rn
    from users u
    join movierating m on m.user_id = u.user_id
    group by name
),
d2 as (
    select title as results, avg(rating) as rt,
    row_number() over (order by avg(rating) desc, title asc)rn
    from movies m
    join movierating m1 on m.movie_id = m1.movie_id
    where date_format(created_at, "%Y-%m") = "2020-02"
    group by title
)
select results
from (
    select results
    from d1
    where rn = 1
    union all
    select results
    from d2
    where rn = 1
)t