select patient_id, patient_name, conditions
from patients
where conditions like 'diab1%'
or conditions like '% diab1%'
or conditions like '% diab1'

select patiend_id, patient_name, conditions
from patients
where conditions regexp '^diab1'
or conditions regexp ' diab1$'
or conditions regexp ' diab1'

def find_patients(patients: pd.DataFrame) -> pd.DataFrame:
    -- method 1
    patients = patients[patients["conditions"].str.contains(r'(^DIAB1)|( DIAB1)')]
    -- method 2
    patients = patients[
        patients["conditions"].str.contains(r'\bDIAB1')
    ]
    return patients