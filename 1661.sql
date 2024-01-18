select a1.machine_id, round(avg(a2.timestamp-a1.timestamp), 3) processing_time
from activity a1
join activity a2
on a1.machine_id = a2.machine_id and a1.process_id = a2.process_id
where a1.activity_type = 'start' and a2.activity_id = 'end'
group by machine_id

select a.machine_id, round(
    (select avg(a1.timestamp) from activity a1 where a1.activity_type = 'end' and a1.machine_id = a.machine_id) -
    (select avg(a1.timestamp) from activity a1 where a1.activity_type = 'start' and a1.machine_id = a.machine_id), 3
) processing_time
from activity a
group by a.machine_id

def get_average_time(activity: pd.DataFrame) -> pd.DataFrame:
    -- method 1
    res = activity.merge(
        activity,
        how="inner",
        on=["machine_id", "process_id"]
    )
    res = res[
        (res.activity_type_x == "start") &
        (res.activity_type_y == "end")
    ]
    res.timestamp = res.timestamp_y - res.timestamp_x
    res = res.groupby(["machine_id"]).agg({
        "timestamp": np.average
    }).rename(columns={"timestamp": "processing_time"}).reset_index()
    res.timestamp = round(res.timestamp, 3)
    return res[["machine_id", "processing_time"]]

    -- method 2: pivot method https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.pivot.html
    res = activity.pivot(
        index=["machine_id", "process_id"],
        columns="activity_type",
        values="timestamp"
    )
    res["processing_time"] = res["end"] - res["start"]
    res = res.groupby(["machine_id"]).processing_time.mean().round(3).reset_index()
    return res[["machine_id", "processing_time"]]

    -- method 3: chain solution
    res = activity.pivot(
        index=["machine_id", "process_id"],
        columns="activity_type",
        values="timestamp",
    ).groupby(["machine_id"]).apply(
        lambda row: (row["end"] - row["start"]).mean().round(3)
    ).rename("processing_time").reset_index()
    return res