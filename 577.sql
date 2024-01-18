-- left join
select name, bonus
from employee e
join bonus b ob b.empId = e.empId
where (b.bonus < 1000 or b.bonus is null)

-- right join
select name, bonus
from bonus b
right join employee e
on e.empId = b.empId
where (b.bonus < 1000 or b.bonus is null)

def employee_bonus(employee: pd.DataFrame, bonus: pd.DataFrame) -> pd.DataFrame:
    -- left join
    res = employee.merge(
        bonus,
        how="left",
        on=["empId"],
    )
    res = res[(res["bonus"].isnull()) | (res["bonus"] < 1000)]
    return res[["name", "bonus"]]

    -- right join
    res = bonus.merge(
        employee,
        how="right",
        on=["empId"],
    )
    res = res[(res["bonus"].isnull()) | (res["bonus"] < 1000)]
    return res[["name", "bonus"]]