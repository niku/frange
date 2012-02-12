# -*- coding: utf-8 -*-
require "spec_helper"

module Frange
  module Filters
    describe ToTwitter do
      subject do
        described_filter = described_class
        Frange.draft do |d|
          d.source { |y| y << "わぁいなりたあかりなりただいすき" }
          d.filter &described_filter
        end
      end
      it "should config" do
        Twitter.should_receive(:consumer_key=).with("twitter_consumer_key")
        Twitter.should_receive(:consumer_secret=).with("twitter_consumer_secret")
        Twitter.should_receive(:oauth_token=).with("twitter_oauth_token")
        Twitter.should_receive(:oauth_token_secret=).with("twitter_oauth_token_secret")
        Twitter.should_receive(:update).with("わぁいなりたあかりなりただいすき")
        subject.build(
                      twitter_consumer_key: "twitter_consumer_key",
                      twitter_consumer_secret: "twitter_consumer_secret",
                      twitter_oauth_token: "twitter_oauth_token",
                      twitter_oauth_token_secret: "twitter_oauth_token_secret"
                      ).next
      end
    end
  end
end
