delete p1 from person p1, person p2
where p1.email = p2.email
and p1.id > p2.id

def delete_duplicate_emails(person: pd.DataFrame) -> None:
    person.sort_values(["id"], inplace=True)
    person.drop_duplicates(subset=["email"], inplace=True)