require 'test_no_rails_helper'
require 'feed_methods'

class DummyFeedClass
  include Podcastfarm::FeedMethods
  attr_accessor :title, :description, :users
  @users = []
end

module Feedzirra
  class Feed
  end
end

describe "Podcastfarm::FeedMethods" do

  let(:feed) { DummyFeedClass.new }
  let(:parser) { mock() }
  let(:feed_data) {{
      :title => "Example Feed",
      :description => "This is test feed.",
      :url => "http://example.com/feed.rss"
    }}

  describe "get_feed_information method" do
    context('valid feed') do
      before(:each) do
        Feedzirra::Feed.expects(:fetch_and_parse).returns(parser)
        parser.expects(:respond_to?).with(:title).returns(true)
        parser.expects(:respond_to?).with(:description).returns(true)
        parser.expects(:title).returns(feed_data[:title])
        parser.expects(:description).returns(feed_data[:description])
        feed.expects(:url).returns(feed_data[:url])
        feed.send(:get_feed_infomation)
      end

      it "should set initial attributes" do
        feed.title.must_equal feed_data[:title]
        feed.description.must_equal feed_data[:description]
      end
    end

    context "404 feed" do
      let(:url) { not_found_url }
      describe "title" do
        it "should be empty" do
          feed.title.must_equal nil
        end
      end
      describe "description" do
        it "should be empty" do
          feed.description.must_equal nil
        end
      end
    end
  end
end
