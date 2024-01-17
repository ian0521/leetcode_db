select tweet_id from Tweets
where length(ifnull(content, 0)) > 15

select tweet_id from Tweets
where length(coalesce(content, 0)) > 15