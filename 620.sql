select id, movie, description, rating
from cinema c
where mod(id, 2) = 1 and description != 'boring'
order by rating desc

def not_boring_movies(
    cinema: pd.DataFrame
) -> pd.DataFrame:
    res = cinema[
        (cinema["id"] & 2 == 1) &
        (cinema["description"] != "boring")
    ].sort_values(["rating"], ascending=False)
    return res[["id", "movie", "description", "rating"]]
