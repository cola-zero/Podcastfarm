require 'test_no_rails_helper'
SimpleCov.command_name 'test:units' if ENV["COVERAGE"]
require 'feed_methods'

class DummyFeedClass
  include Podcastfarm::FeedMethods
  attr_accessor :url, :title, :description, :users, :errors, :id
  @id = 1
  @users = []
end

module Feedzirra
  class Feed
  end
end

class Entry; end

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
        feed.expects(:url).at_least(1).returns(feed_data[:url])
        feed.send(:get_feed_infomation)
      end

      it "should set initial attributes" do
        feed.title.must_equal feed_data[:title]
        feed.description.must_equal feed_data[:description]
      end
    end

    context "when url is given" do
      context "when feed's url is not set yet." do
        it "must set url" do
          Feedzirra::Feed.expects(:fetch_and_parse).returns(parser)
          feed_data.merge!( :url => nil)
          feed.url.must_equal nil
          feed.get_feed_infomation( "http://example.com/feed2.rss")
          feed.url.must_equal "http://example.com/feed2.rss"
        end
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

  describe "update_feed" do
    let(:parser) { mock }

    def mock_parser
      Feedzirra::Feed.expects(:fetch_and_parse).returns(parser)
      feed.send(:make_parser)
    end

    it "must respond_to update_feed method" do
      feed.must_respond_to( :update_feed )
    end

    describe "behavior of this method" do
      let(:entry_parser) { mock }
      let(:tmp_relation) { mock }
      let(:entry) { mock}

      before(:each) do
        mock_parser
        parser.expects(:entries).returns( [entry_parser, entry_parser])
        Entry.expects(:in_this_feed).with(@id).twice.returns(tmp_relation)
        entry.expects(:get_entry_information).with(entry_parser).twice
      end

      it "must create each entries" do
        tmp_relation.expects(:find_from_parser).with(entry_parser).twice.returns( [] )
        Entry.expects(:new).twice.returns(entry)
        feed.update_feed
      end

      it "must update exist entries" do
        tmp_relation.expects(:find_from_parser).with(entry_parser).twice.returns( [entry] )
        feed.update_feed
      end
    end
  end

  describe "url_is_valid method" do
    before do
      feed.url = "http://example.com/"
    end

    it "should be valid" do
      feed.send(:url_is_valid).must_equal true
    end

    context "url is not valid" do
      let(:errors) { mock }
      before do
        feed.url = "htp://invalid_url/"
        feed.errors = errors
      end

      it "should not be valid" do
        errors.expects(:add).returns(false)
        feed.send(:url_is_valid).must_equal false
      end

      context "when url has no scheme" do

        before do
          feed.url = "invalid_url"
        end
        it "should not be valid" do
          errors.expects(:add).returns(false)
          feed.send(:url_is_valid).must_equal false
        end
      end
    end
  end
end
