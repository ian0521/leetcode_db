select employee_id
from employees
where salary < 30000
and manager_id not in (
    select employee_id
    from employees
)
order by employee_id

def find_employees(
    employees: pd.DataFrame
) -> pd.DataFrame:
    res = employees[
        (employees["salary"] < 30000) &
        (~employees["manager_id"].isin(employees["employee_id"])) &
        (~employees["manager_id"].isna()) -- can use notnull() or != None too
    ]
    return res[["employee_id"]].sort_values(
        by=["employee_id"],
        ascending=True
    )