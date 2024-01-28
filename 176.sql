select max(salary) as SecondHighestSalary
from employee
where salary < (
    select max(salary)
    from employee
)


def second_highest_salary(
    employee: pd.DataFrame
) -> pd.DataFrame:
    max_salary = employee["salary"].max()
    employee = employee.query(
        f"""salary < {max_salary}"""
    )
    salary = employee["salary"].max()
    return pd.DataFrame(data={
        "SecondHighestSalary": [salary],
    })