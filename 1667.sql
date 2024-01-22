select
    user_id,
    concat(upper(substring(name, 1, 1)), lower(substring(name, 2))) name
from users
order by user_id

def fix_names(users: pd.DataFrame) -> pd.DataFrame:
    res = users.assign(
        name = lambda row: row["name"].str.capitalize()
    )
    return res.sort_values(by=["user_id"])