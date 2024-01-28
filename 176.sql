select max(salary) as SecondHighestSalary
from employee
where salary < (
    select max(salary)
    from employee
)


def second_highest_salary(
    employee: pd.DataFrame
) -> pd.DataFrame:
    -- method 1
    max_salary = employee["salary"].max()
    employee = employee.query(
        f"""salary < {max_salary}"""
    )
    salary = employee["salary"].max()
    return pd.DataFrame(data={
        "SecondHighestSalary": [salary],
    })

    -- method 2
    unique_salary = employee["salary"].sort_values(
        ascending=False
    ).drop_duplicates()
    if len(unique_salary) < 2:
        return pd.DataFrame(data={
            "SecondHighestSalary": [None],
        })
    return pd.DataFrame(data={
        "SecondHighestSalary": [unique_salary.iloc[1]]
    })