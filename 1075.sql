select p.project_id, round(avg(experience_years), 2) as average_years
from project p
left join employee e
on e.employee_id = p.employee_id
group by project_id

def project_employees_i(
    project: pd.DataFrame,
    employee: pd.DataFrame
) -> pd.DataFrame:
    res = project.merge(
        employee,
        how="left",
        on=["employee_id"],
    )
    res = res.groupby(["project_id"])["experience_years"].mean().round(2).rename("average_years").reset_index()
    return res[["project_id", "average_years"]]