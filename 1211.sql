select query_name, round(avg(rating/position), 2) as quality,
round(
    sum(case when rating < 3 then 1 else 0 end)/count(*) * 100,
    2
) as poor_query_percentage
from queries
where query_name is not null
group by query_name

def queries_stats(queries: pd.DataFrame) -> pd.DataFrame:
    -- method 1
    queries["quality"] = queries.apply(
        lambda row: row["rating"]/row["position"] + 1e-10,
        axis=1,
    )
    quality = queries.groupby(["query_name"])["quality"].mean().round(2).rename("quality").reset_index()
    size = queries.groupby(["query_name"]).size().rename("size").reset_index()
    poor = queries.query("rating < 3").groupby(["query_name"]).size().rename("poor").reset_index()
    res = size.merge(
        poor,
        how="left",
        on=["query_name"],
    )
    res["poor_query_percentage"] = res.apply(
        lambda row: round(row["poor"]/row["size"]*100, 2),
        axis=1,
    )
    res = res.merge(
        quality,
        how="outer",
        on=["query_name"],
    ).fillna(0)
    return res[["query_name", "quality", "poor_query_percentage"]]

    -- method 2
    queries = queries.assign(
        quality = queries.rating/queries.position + 1e-10,
        poor_query_percentage = (queries.rating < 3).astype(int)*100
    )
    queries = queries.assign(
        quality = lambda row: row.rating/row.position + 1e-10,
        poor_query_percentage = lambda row: (row.rating < 3).astype(int)*100
    )
    res = queries.groupby(["query_name"])[["quality", "poor_query_percentage"]].mean().round(2).reset_index()
    return res[["query_name", "quality", "poor_query_percentage"]]