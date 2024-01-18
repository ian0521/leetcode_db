select w1.id from weather w1
left join weather w2
on w1.recordDate = date_add(w2.recordDate, interval 1 day)
where w1.temperature > w2.temperature
-- where w1.temperature > coalesce(w2.temperature, w1.temperature - 1)

def rising_temperature(weather: pd.DataFrame) -> pd.DataFrame:
    weather.sort_values("recordDate", ascending=True, inplace=True)
    weather["recordDate"] = pd.to_datetime(weather["recordDate"])

    weather["pre_temperature"] = weather.temperature.shift(1)
    weather["pre_date"] = weather.recordDate.shift(1)
    res = weather[(weather.temperature > weather.pre_temperature) &
        (weather.recordDate - weather.pre_date == pd.Timedelta(days=1))
    ]
    return res[["id"]]