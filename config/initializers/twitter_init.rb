# Twitter configuration
module ForcastTweeter
  module Configuration
    def defaults
      {
        consumer_key: ENV['TWTR_CONSUMER_KEY'],
        consumer_secret: ENV['TWTR_CONSUMER_SECRET'],
        access_token: ENV['TWTR_ACCESS_TOKEN'],
        access_token_secret: ENV['TWTR_ACCESS_SECRET'],
      }
    end
  end

  extend Configuration
end
