-- method 1
with data as (
    select
        p.product_name, date_format(o.order_date, "%Y-%m") month, sum(unit) unit
    from products p
    join orders o on p.product_id = o.product_id
    group by p.product_name, date_format(o.order_date, "%Y-%m")
)
select d.product_name, d.unit
from data d
where month = '2020-02'
and unit >= 100

-- method 2
select product_name, sum(unit) unit
from products p
join orders o on p.product_id = o.product_id
where date_format(order_date, "%Y-%m") = "2020-02"
group by date_format(order_date, "%Y-%m"), p.product_name
having sum(unit) >= 100

def list_products(
    products: pd.DataFrame,
    orders: pd.DataFrame,
) -> pd.DataFrame:
    res = products.merge(
        orders,
        how="inner",
        on=["product_id"],
    )
    res["order_date"] = res["order_date"].dt.strftime("%Y-%m")
    res = res.groupby(["product_name", "order_date"]).agg({
        "unit": "sum"
    }).reset_index()
    res = res.query("unit >= 100 and order_date == '2020-02'")
    return res[["product_name", "unit"]]