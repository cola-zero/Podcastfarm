# == Schema Information
#
# Table name: feeds
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  url         :string(255)     not null
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Feed do
  let(:feed) { Feed.new(attr) }
  let(:attr) { { :url => url } }
  let(:url)  { "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "feed.rss"))}" }
  let(:not_found_url) { "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "not_found.rss"))}" }

  it 'can be created' do
    feed.should_not be_nil
  end

  it "should be valid" do
    feed.should be_valid
  end

  context "invalid attribute" do
    context "when url is not present" do
      let(:url) { nil }
      it "should not be valid" do
        feed.should_not be_valid
      end
    end

    context "when url is duplicated" do
      it "should not save to db" do
        feed.save
        lambda{ Feed.create(attr) }.should change(Feed, :count).by(0)
      end
    end
  end

  describe "attribute validater" do
    context "url is valid" do
      let(:url) { "http://example.com/" }
      it "should be valid" do
        feed.send(:url_is_valid).should be_true
      end
    end
    context "url is not valid" do
      let(:url) { "htp://invadlid_url/" }
      it "should not be valid" do
        feed.should_not be_valid
      end
      context "when url has no scheme" do
        let(:url) { "invalid_url" }
        it "should not be valid" do
          feed.should_not be_valid
        end
      end
    end
  end

  describe "get_feed_infomation" do
    before(:each) do
      feed.send(:get_feed_infomation)
    end

    it "should set initial attributes" do
      feed.title.should == "Example Feed"
      feed.description.should == "This is test feed."
    end
    context "404 feed" do
      let(:url) { not_found_url }
      describe "title" do
        it "should be empty" do
          feed.title.should be_empty
        end
      end
      describe "description" do
        it "should be empty" do
          feed.description.should be_empty
        end
      end
    end
  end

  describe "find_or_create method" do
    context "when new url" do
      it "should create new feed"do
        expect{ Feed.find_or_create_by_url(url)}.to
        change(Feed, :count).by(1)
      end
    end

    context "when url is exist" do
      before do
        feed.save
      end
      it "should return exist feed" do
        Feed.find_or_create_by_url(url).should == feed
      end
    end
  end

  describe "user association" do
    subject { feed }
    it { should respond_to(:users) }
  end

  describe ".register_user method" do
    subject { Feed.create( :url => url ) }
    it { should respond_to(:register_user) }

    describe "assign users" do
      let(:user) { Factory(:user) }
      let(:feed) { Feed.create( :url => url )}

      before do
        feed.register_user(user)
      end

      it "should add user" do
        feed = Feed.find_by_url(url)
        feed.users.should eq([user])
      end

      let(:second_user) { Factory(:user) }
      it "should add another user" do
        feed.register_user(second_user)
        feed = Feed.find_by_url(url)
        feed.users.should eq([user, second_user])
      end

      it "should not add same user" do
        feed.register_user(user)
        feed.register_user(user)
        feed = Feed.find_by_url(url)
        feed.users.should eq([user])
      end

    end

    describe "invalid arguments" do
      context "user is nil" do
        it "should return false" do
          feed.register_user(nil).should be_false
        end

        it "should not add feed" do
          lambda{ feed.register_user(nil)}.should
          change(Feed, :count).by(0)
        end

        it "should not add users" do
          feed = Feed.find_or_create_by_url(url)
          lambda{ feed.register_user(nil)}.should \
          change(Feed.find_by_url(url).users, :size).by(0)
        end
      end
    end
  end

  describe ".unregister_user method" do
    subject { Feed.create( :url => url ) }
    it { should respond_to(:unregister_user) }

    let(:feed) { Feed.create( :url => url) }
    let(:user) { Factory(:user)}
    before do
      feed.register_user user
    end

    it "should remove user from feed.users" do
      feed.users.should eq [user]
      user.feeds.should eq [feed]
      feed.unregister_user(user)
      feed.users.should eq []
      user.feeds.should eq []
    end

  end
end
