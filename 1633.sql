-- method 1
select
    contest_id,
    round(count(r.user_id)/(select count(distinct user_id) from users) * 100, 2) as percentage
from users u
left join register r
on r.user_id = u.user_id
where contest_id is not null
group by contest_id
order by percentage desc, contest_id asc

-- method 2
select
    contest_id,
    round(count(distinct user_id) * 100 / (select count(user_id) from users), 2) as percentage
from register
group by contest_id
order by percentage desc, contest_id asc

def users_percentage(
    users: pd.DataFrame,
    register: pd.DataFrame
) -> pd.DataFrame:
    int_all_students = len(users["user_id"].unique())
    res = register.groupby(["contest_id"]).size().rename("count").reset_index()
    res["percentage"] = res.apply(
        lambda row: ((row["count"]/int_all_students)*100).round(2),
        axis=1
    )
    return res[["contest_id", "percentage"]].sort_values(
        ["percentage", "contest_id"],
        ascending=[False, True]
    )