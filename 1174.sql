with date as (
    select customer_id, order_date, customer_pref_delivery_date,
    row_number() over (partition by customer_id order by order_date) rn
    from delivery d
)
select 
round(
    sum(case when order_date = customer_pref_delivery_date then 1 else 0 end)/
    count(*) * 100,
2) as immediate_percentage
from data
where rn = 1

def immediate_food_delivery(delivery: pd.DataFrame) -> pd.DataFrame:
    res = delivery.sort_values(by=["customer_id", "order_date"], ascending=[True, True])
    res = res.groupby(["customer_id"]).agg({
        "order_date": "first"
    }).reset_index()
    res = res.merge(
        delivery,
        how="left",
        on=["customer_id", "order_date"],
    )
    res = res.assign(
        immediate = lambda row: (row.order_date == row.customer_pref_delivery_date).astype(int)
    )
    return pd.DataFrame(data={(res["immediate"].mean()*100).round(2)}, columns=["immediate_percentage"])