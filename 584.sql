select name from Customer
where referee_id != 2 or referee_id is null

select name from customer
where ifnull(referee_id, 0) != 2

select name from customer
where coalesce(referee_id, 0) != 2 --return the first non-null value

def find_customer_referee(customer: pd.DataFrame) -> pd.DataFrame:
    -- method 1
    res = customer.loc[lambda row: (row["referee_id"] != 2) | (row["referee_id"].isna())] -- isna() to find empty value
    return res[["name"]]

    -- method 2
    res = customer[(customer["referee_id"] != 2) | (customer["referee_id"].isna())]
    return res[["name"]]

    -- method 2 would be more efficient when the dataframe is large, the method 2 filters by columns, while the method 1 iter for each row.