require 'test_no_rails_helper'
SimpleCov.command_name 'test:units' if ENV["COVERAGE"]
require 'feed_manager'

class Feed; end

describe Podcastfarm::FeedManager do
  subject { Podcastfarm::FeedManager }
  let(:feed) { mock }
  let(:user) { mock() }
  let(:url)  { "http://example.com/feed.rss" }

  describe "find_or_create_feed method" do
    it "must_respond_to find_or_create_feed" do
      subject.must_respond_to( :find_or_create_feed )
    end

    context "when create new feed" do
      it "must create new feed" do
        Feed.expects(:find_by_url).with(url).returns(nil)
        Feed.expects(:new).returns(feed)
        feed.expects(:get_feed_infomation).with(url)
        subject.find_or_create_feed(url).must_equal feed
      end

      # it "must create each items in feed" do
      # end
    end

    context "when feed are exist" do
      it "must find feed" do
        Feed.expects(:find_by_url).with(url).returns feed
        subject.find_or_create_feed(url).must_equal feed
      end
    end
  end

  describe "register_user" do
    it "must_respond_to register_user" do
      subject.must_respond_to( :register_user )
    end

    let(:users) { [] }

    let(:act_as_register_user) {
      feed.expects(:users).returns(users)
    }

    it "must add user to feed.users" do
      act_as_register_user
      subject.register_user(feed, user).must_equal([user])
    end

    context "when feed is already registered" do
      it "must be unieque" do
        users = [user]
        act_as_register_user
        subject.register_user(feed, user).must_equal([user])
      end
    end
  end

  describe "unregister_user" do
    it "must_respond_to unregister_user" do
      subject.must_respond_to( :unregister_user)
    end

    let(:users) { [user] }
    let(:feeds) { [feed] }
    let(:act_as_unregister_user) {
      feed.expects(:users).at_least(1).returns users
      user.expects(:feeds).at_least(1).returns feeds
    }

    context "when feed are registered" do
      it "must unregister user" do
        act_as_unregister_user
        subject.unregister_user(feed, user)
        feeds.must_be :empty?
        users.must_be :empty?
      end
    end

    context "when feed are not registered" do
      let(:users) { [] }
      let(:feeds) { [] }

      it 'must be silent' do
        act_as_unregister_user
        lambda{ subject.unregister_user(feed, user) }.must_be_silent
        users.must_be :empty?
        feeds.must_be :empty?
      end
    end
  end
end
