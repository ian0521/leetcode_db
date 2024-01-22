select
    date_format(trans_date, "%Y-%m") as month,
    country,
    count(*) as trans_count,
    sum(case when state = "approved" then 1 else 0 end) as approved_count,
    sum(amount) as trans_total_amount,
    sum(case when state = "approved" then amount else 0 end) as approved_total_amount
from transactions
group by month, country

def monthly_transactions(
    transactions: pd.DataFrame
) -> pd.DataFrame:
    transactions["country"] = transactions["country"].fillna("unknown")
    transactions["trans_date"] = pd.to_datetime(transactions["trans_date"])
    transactions = transactions.assing(
        month: lambda row: row["trans_date"].dt.strftime("%Y-%m"),
        approved_count: lambda row: (row.state == "approved").astype(int),
        approved_total_amount: lambda row: (row.state == "approved").astype(int) * row.amount,
    )
    res = transactions.groupby(
        ["month", "country"]
    ).agg({
        "id": "size",
        "approved_count": "sum",
        "amount": "sum",
        "approved_total_amount": "sum",
    }).rename(columns={
        "id": "trans_count",
        "amount": "trans_total_amount"
    }).reset_inde()
    res["country"].replace("unknown", np.nan, inplace=True)
    return res