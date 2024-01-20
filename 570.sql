-- nest query
select name from employee e
where id in (
    select managerId from employee
    group by managerId
    having count(*) >= 5
)

-- join
select e2.name
from employee e1
join employee e2
on e2.id = e1.managerId
group by e2.id
having count(*) >= 5

def find_managers(employee: pd.DataFrame) -> pd.DataFrame:
    -- method 1
    lst = employee.groupby(["managerId"]).size().rename(name="count")
    lst = lst[lst["managerId"] >= 5]["managerId"] -- lst=lst.query("count >= 5")["managerId"]
    res = res.loc[lambda row: row["managerId"].isin(lst)]
    return res[["name"]]

    --  method 2
    res = employee.merge(
        employee,
        how="inner",
        left_on="managerId",
        right_on="id",
    )
    res["name_y"].fillna(np.nan, inplace=True)
    -- res["name_y"] = res["name_y"].fillna("Unknown")
    res = res.groupby(["managerId_x", "id_y"]).size().reset_index(name="count")
    res = res[res["count"] >= 5].rename(columns={"name_y": "name"})
    res["name"] = res["name"].replace("Unknown", np.nan)
    return res[["name"]]