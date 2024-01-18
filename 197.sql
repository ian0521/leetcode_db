select w1.id from weather w1
left join weather w2
on w1.recordDate = date_add(w2.recordDate, interval 1 day)
where w1.temperature > w2.temperature
-- where w1.temperature > coalesce(w2.temperature, w1.temperature - 1)

