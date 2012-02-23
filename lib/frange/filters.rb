require "twitter"

module Frange
  module Filters
    ToTwitter = ->(params, input) {
      Twitter.configure do |config|
        config.consumer_key = params[:twitter_consumer_key]
        config.consumer_secret = params[:twitter_consumer_secret]
        config.oauth_token = params[:twitter_oauth_token]
        config.oauth_token_secret = params[:twitter_oauth_token_secret]
      end
      Twitter.update(input)
    }
  end
end
