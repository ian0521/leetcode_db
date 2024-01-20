select s.user_id,
round(sum(
    case when action = "confirmed" then 1 else 0 end
    )/count(*)
, 2) confirmation_rate
from signups s
left join confirmations c
on c.user_id = s.user_id
group by s.user_id

def confirmation_rate(
    signups: pd.DataFrame,
    confirmations: pd.DataFrame
) -> pd.DataFrame:
    res = signups.merge(
        confirmations,
        how="left",
        on="user_id",
    )
    res["action"] = res.apply(
        lambda row: 1 if row["action"] == "confirmed" else 0,
        axis=1
    )
    res = res.groupby(["user_id"])[["action"]].mean().round(2).rename(
        columns={"action":"confirmation_rate"}).reset_index()
    return res[["user_id", "confirmation_rate"]]