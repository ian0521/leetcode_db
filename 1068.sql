select product_name, year, price
from Sales s
left join Product p
on p.product_id = s.product_id


select product_name, year, price
from product p
right join sales s
on s.product_id = p.product_id


def sales_analysis(sales: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
    --  left join 
    res = sales.merge(
        product,
        how="left",
        on=["product_id"]
    )
    return res[["product_name", "year", "price"]]

    -- right join
    res = product.merge(
        sales,
        how="right",
        on=["product_id"]
    )
    return res[["product_name", "year", "price"]]

    -- inner join
    res = product.merge(
        sales,
        how="inner",
        on=["product_id"]
    )
    return res[["product_name", "year", "price"]]