select unique_id, name
from Employees e
left join EmployeeUNI eu
on e.id = eu.id

select unique_id, name
from EmployeeUNI eu
right join Employee e
on eu.id = e.id

def replace_employee_id(employees: pd.DataFrame, employee_uni: pd.DataFrame) -> pd.DataFrame:
    -- left join
    res = employees.merge(
        employee_uni,
        how="left",
        on=["id"]
    )
    return res[["unique_id", "name"]]

    -- right join
    res = employee_uni.merge(
        employees,
        how="right",
        on=["id"]
    )
    return res[["unique_id", "name"]]