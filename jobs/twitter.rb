require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
Twitter.configure do |config|
  config.consumer_key = "5IS9EMeLTwyywHZu64S85g"
  config.consumer_secret = "DUMdUMytkyqJJz3gWo5Y4PMO7Qz7LkqK9wKUvWnxc"
  config.oauth_token = "1671750709-E49EZBjzPwWBl5pjpfpI3rDpCPjKPZKercW4WUl"
  config.oauth_token_secret = "L6XbZrdLbM0TgQIZaKVR2sWUkwCvBdVktx6c6POEkIY"
end

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = Twitter.mentions_timeline

    if tweets
      tweets.map! do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end