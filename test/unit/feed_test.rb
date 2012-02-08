require 'test_helper'

describe Feed do

  let(:feed) { Feed.new(attr) }
  let(:attr) { { :url => url } }
  let(:url)  { "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "feed.rss"))}" }
  let(:not_found_url) { "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "not_found.rss"))}" }

  it 'can be created' do
    feed.wont_equal nil
  end

  it "should be valid" do
    feed.must_be :valid?
  end

  context "invalid attribute" do
    context "when url is not present" do
      let(:url) { nil }
      it "should not be valid" do
        feed.wont_be :valid?
      end
    end

    context "when url is duplicated" do
      it "should not save to db" do
        feed.save
        before = Feed.count
        Feed.create(attr)
        Feed.count.must_equal(before)
      end
    end
  end

  describe "attribute validater" do
    context "url is valid" do
      let(:url) { "http://example.com/" }
      it "should be valid" do
        feed.send(:url_is_valid).must_equal true
      end
    end
    context "url is not valid" do
      let(:url) { "htp://invadlid_url/" }
      it "should not be valid" do
        feed.wont_be :valid?
      end
      context "when url has no scheme" do
        let(:url) { "invalid_url" }
        it "should not be valid" do
          feed.wont_be :valid?
        end
      end
    end
  end

  describe "get_feed_infomation" do
    before(:each) do
      feed.send(:get_feed_infomation)
    end

    it "should set initial attributes" do
      feed.title.must_equal "Example Feed"
      feed.description.must_equal "This is test feed."
    end
    context "404 feed" do
      let(:url) { not_found_url }
      describe "title" do
        it "should be empty" do
          feed.title.must_be :empty?
        end
      end
      describe "description" do
        it "should be empty" do
          feed.description.must_be :empty?
        end
      end
    end
  end

  describe "find_or_create method" do
    context "when new url" do
      it "should create new feed"do
        before = Feed.count
        Feed.find_or_create_by_url(url)
        Feed.count.must_be_close_to(before, 1)
      end
    end

    context "when url is exist" do
      before (:each) do
        feed.save
      end
      it "should return exist feed" do
        Feed.find_or_create_by_url(url).must_equal feed
      end
    end
  end

  describe "user association" do
    subject { feed }
    it "must_respond_to(:users)" do
      subject.must_respond_to(:users)
    end
  end

  describe ".register_user method" do
    subject { Feed.create( :url => url ) }
    it "must_respond_to(:register_user)" do
      subject.must_respond_to(:register_user)
    end

    describe "assign users" do
      let(:user) { Factory(:user) }
      let(:feed) { Feed.create( :url => url )}

      before (:each) do
        feed.register_user(user)
      end

      it "should add user" do
        feed = Feed.find_by_url(url)
        feed.users.must_equal([user])
      end

      let(:second_user) { Factory(:user) }
      it "should add another user" do
        feed.register_user(second_user)
        feed = Feed.find_by_url(url)
        feed.users.must_equal([user, second_user])
      end

      it "should not add same user" do
        feed.register_user(user)
        feed.register_user(user)
        feed = Feed.find_by_url(url)
        feed.users.must_equal([user])
      end

    end

    describe "invalid arguments" do
      context "user is nil" do
        it "should return false" do
          feed.register_user(nil).must_equal false
        end

        it "should not add feed" do
          before = Feed.count
          feed.register_user(nil)
          Feed.count.must_be_close_to(before, 0)
        end

        it "should not add users" do
          feed = Feed.find_or_create_by_url(url)
          before = Feed.count
          feed.register_user(nil)
          Feed.count.must_be_close_to(before, 0)
        end
      end
    end
  end

  describe ".unregister_user method" do
    subject { Feed.create( :url => url ) }
    it { subject.must_respond_to(:unregister_user) }

    let(:feed) { Feed.create( :url => url) }
    let(:user) { Factory(:user)}
    before (:each) do
      feed.register_user user
    end

    it "should remove user from feed.users" do
      feed.users.must_equal [user]
      user.feeds.must_equal [feed]
      feed.unregister_user(user)
      feed.users.must_equal []
      user.feeds.must_equal []
    end

  end
end
