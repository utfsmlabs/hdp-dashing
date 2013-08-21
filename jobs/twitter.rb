require 'twitter'
settings = YAML.load_file("config.yaml")

#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
Twitter.configure do |config|
  config.consumer_key = settings["config"]["consumer_key"]
  config.consumer_secret = settings["config"]["consumer_secret"]
  config.oauth_token = settings["config"]["oauth_token"]
  config.oauth_token_secret = settings["config"]["oauth_token_secret"]
end

SCHEDULER.every '5m', :first_in => 0 do |job|
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
