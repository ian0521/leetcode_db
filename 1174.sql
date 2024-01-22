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
    -- method 1: less efficient when data is large
    res = delivery.sort_values(by=["customer_id", "order_date"], ascending=[True, True])
    res = res.groupby(["customer_id"]).agg({
        "order_date": "first"
    }).reset_index()
    -- method 2: more efficient
    res = delivery.groupby(["customer_id"]).agg({
        "order_date": "min"
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

    -- method 3
    df_temp = df.sort_values(["customer_id", "order_date"], ascending=[True, True])
    df_group = df_temp.groupby(["customer_id"]).head(1)
    immediate_percentage = len(df_group[df_group["order_date"] == df_group["customer_pref_delivery_date"]])/len(df_group)
    return pd.DataFrame({"immediate_percentage":[round(immediate_percentage * 100,2)]})