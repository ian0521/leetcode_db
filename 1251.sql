select
    p.product_id,
    ifnull(round(sum(price*units)/sum(units), 2), 0) average_price
from prices p
left join unitssold us
on p.product_id = us.product_id
and purchase_date between start_date and end_date
group by product_id

def average_selling_price(
    prices: pd.DataFrame,
    unitssold: pd.DataFrame
) -> pd.DataFrame:
    -- method 1
    res = prices.merge(
        units_sold,
        how="left",
        on=["product_id"],
    ).query(
        "(purchase_date >= start_date and purchase_date <= end_date) or (purchase_date.isnull())"
    )
    res["total"] = res.apply(
        lambda row: row["price"] * row["units"],
        axis=1
    )
    res = res.groupby(["product_id"])[["units", "total"]].sum().reset_index()
    res["average_price"] = res.apply(
        lambda row: round((row["total"]/row["units"]) if row["units"] != 0 else 0, 2),
        axis=1
    )
    return res[["product_id", "average_price"]]

    -- method 2: merge_asof https://pandas.pydata.org/docs/reference/api/pandas.merge_asof.html
    all_product_ids = pd.DataFrame({
        "product_id": pd.concat([
            prices["product_id"], units_sold["product_id"]
        ]).unique()
    })
    prices = prices.sort_values(["start_date"], ascending=True)
    units_sold = units_sold.sort_values(["purchase_date"], ascending=True)
    res = pd.merge_asof(
        units_sold,
        prices,
        left_on="purchase_date",
        right_on="start_date",
        by="product_id",
        direction="backward"
    )
    res = pd.merge(
        all_product_ids, res,
        how="left",
        on="product_id"
    ).fillna(0)
    res["total"] = res.apply(
        lambda row: row["units"] * row["price"],
        axis=1,
    )
    res = res.groupby(["product_id"])[["units", "total"]].sum().reset_index()
    res["average_price"] = res.apply(
        lambda row: round((row["total"]/row["units"]) if row["units"] != 0 else 0, 2),
        axis=1,
    )
    return res[["product_id", "average_price"]]