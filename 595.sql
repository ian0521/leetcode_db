select name, population, area
from World
where area >= 3000000
or population >= 25000000

select name, population, area
from World
where area >= 3000000
union
select name, population, area
from World
where population >= 25000000

def big_countries(world: pd.DataFrame) -> pd.DataFrame:
    -- method 1
    res = world[(world["area"] >= 3000000) | (world["population"] >= 25000000)]
    return res[["name", "population", "area"]] 

    -- method 2
    res = world.loc[lambda row: (row["area"] >= 3000000) | (row["population"] >= 25000000)]
    return res[["name", "population", "area"]]