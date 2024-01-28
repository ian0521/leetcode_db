select
    case
    when id % 2 = 0 then id - 1
    when id % 2 != 0 and id = (select count(id) from seat) then id
    else id + 1 end as id,
    student
from seat
order by id

def exchange_seats(
    seat: pd.DataFrame
) -> pd.DataFrame:
    if len(seat) <= 1:
        return seat
    seat["id"] = seat.apply(
        lambda row:
        row["id"] - 1 if row["id"] % 2 == 0
        else row["id"] if row["id"] == seat["id"].max()
        else row["id"] + 1,
        axis=1
    )
    return seat.sort_values(by=["id"], ascending=True)