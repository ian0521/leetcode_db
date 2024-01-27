select * from users
where mail regexp '^[A-Za-z][A-Za-z0-9._-]*@leetcode[.]com'

def valid_emails(users: pd.DataFrame) -> pd.DataFrame:
    -- method 1
    res = users.loc[
        lambda row: row.mail.str.contains(
            r"^[A-Za-z][A-Za-z0-9._-]*@leetcode[.]com$"
        )
    ]
    return res

    -- method 2
    res = users[
        users["mail"].str.match(
            r"^[A-Za-z][A-Za-z0-9._-]*@leetcode[.]com$"
        )
    ]
    return res