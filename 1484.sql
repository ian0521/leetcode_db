select
    sell_date, count(distinct product) num_sold,
    group_concat(distinct product order by product asc separator ',') products
from activities
group by sell_date
order by sell_date desc

def categorize_products(activities: pd.DataFrame) -> pd.DataFrame:
    res = activities.groupby(["sell_date"])["product"].agg([
        ("num_sold", "nunique"),
        ("products", lambda row: ",".join(sorted(row.unique())))
    ]).reset_index()
    return res
