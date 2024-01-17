select product_id from Products
where low_fats = 'Y' and recyclable = 'Y'

import pandas as pd
def find_products(products: pd.DataFrame) -> pd.DataFrame:
    -- method 1
    res = products.loc[lambda row: (row["low_fats"] == "Y") & (row["recyclable"] == "Y")]
    return res[["product_id"]] -- return a DataFrame

    -- method 2
    res = products.query("low_fats == 'Y' and recyclable == 'Y'")
    return res[["product_id"]]

    -- method 3
    res = products[(products["low_fats"] == "Y") & (products["recyclable"] == "Y")]
    return res[["product_id"]]