-- nested query
select customer_id, count(*) as count_no_trans
from Visits
where visit_id not in (
    select visit_id from Transactions
)
group by customer_id

-- join
select customer_id, count(*) as count_no_trans
from visits v
left join transactions t
on t.visit_id = v.visit_id
where amount is null and transaction_id is null
group by customer_id

def find_customers(visits: pd.DataFrame, transactions: pd.DataFrame) -> pd.DataFrame:
    -- method 1
    res = visits.merge(
        transactions,
        how="left",
        on=["visit_id"],
    )
    res = res[(res["transaction_id"].isna()) & (res["amount"].isna())]
    res = res.groupby(["customer_id"], as_index=False).agg(
        count_no_trans=("visit_id", "nunique")
    )
    return res

    -- method 2
    res = visits.merge(
        transactions,
        how="left",
        on=["visit_id"],
    )
    res = res.query("amount.isna() and transaction_id.isna()")
    res = res.groupby(["customer_id"])["visit_id"].count().rename("count_no_trans").reset_index()
    return res