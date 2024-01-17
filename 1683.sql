select tweet_id from Tweets
where length(ifnull(content, 0)) > 15

select tweet_id from Tweets
where length(coalesce(content, 0)) > 15

def invalid_tweets(tweets: pd.DataFrame) -> pd.DataFrame:
    res = tweets[(tweets["content"].str.len() > 15) | (tweets["content"].isna())]
    return res[["tweet_id"]]
