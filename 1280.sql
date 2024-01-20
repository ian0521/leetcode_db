select s.student_id, s.student_name, s1.subject_name, count(e.student_id) attended_exams
from students s
cross join subjects s1
left join examinations e
on e.student_id = s1.subject_name
and e.subject_name = s1.subject_name
group by s.student_id, s.student_name, s1.subject_name
order by s.student_id, s1.subject_name

def students_and_exminations(
    students: pd.DataFrame,
    subjects: pd.DataFrame,
    examinations: pd.DataFrame,
) -> pd.DataFrame:
    res = students.merge(
        subjects,
        how="cross",
    ).merge(
        examinations.groupby([
            "student_id", "subject_name"
        ]).agg(
            attended_exams=("student_id", "count"),
        ).reset_index(),
        how="left",
        on=["student_id", "subject_name"],
    )
    res.attended_exams = res.attended_exams.fillna(0)
    res = res.sort_values(
        ["student_id", "subject_name"],
        ascending=True,
    )
    return res[["student_id", "student_name", "subject_name", "attended_exams"]]