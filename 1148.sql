select distinct author_id as id
from Views
where author_id = viewer_id
order by author_id

def article_views(views: pd.DataFrame) -> pd.DataFrame:
    """
    method 1: change to a list first, and create a new dataframe
    """
    res = list(set(views[views["author_id"] == views["viewer_id"]]["author_id"]))
    df = pd.DataFrame(data=res, columns=["id"])
    return df[["id"]].sort_values(by=["id"], ascending=True)

    -- method 2
    res = views[views["author_id"] == views["viewer_id"]].author_id.unique() -- type array
    df = pd.DataFrame(data=res, columns=["id"])
    return df[["id"]].sort_values(by=["id"], ascending=True)
    
    -- method 3: not to create a new var/param
    unique_ids = views.loc[views["author_id"] == views["viewer_id"], "author_id"].unique() --array
    return pd.DataFrame(data={"id": unique_ids}).sort_values(by="id", ascending=True)

    --method 4: sort the array first
    sort_unique_ids = sorted(views.loc[views["author_id"] == views["viewer_id"], "author_id"].unique())
    return pd.DataFrame(data={"id": sort_unique_ids})

    --method 5
    res = views.loc[
        views["author_id"] == views["viewer_id"],
        ["author_id"]
    ].drop_duplicates().rename(columns={
        "author_id": "id"
    }).sort_values(by=["id"], ascending=True)
    return res