require 'test_helper'
SimpleCov.command_name 'test:inegration' if ENV["COVERAGE"]

describe "Feeds Integration" do
  # include TransactionalTests

  def valid_url
    "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "feed.rss"))}"
  end

  def sign_in
    visit "/auth/twitter"
  end

  def manager
    Podcastfarm::FeedManager
  end
  before(:each)do
    set_omniauth_mock
  end

  describe "GET /feeds" do
    it "should success" do
      visit feeds_path
      page.must_have_selector "h1"
      page.must_have_content "Podcastfarm"
    end

    it "should show feeds" do
      sign_in
      feed = FactoryGirl.create(:feed)
      manager.register_user(feed, User.find_by_nickname("cola_zero"))
      visit feeds_path
      page.must_have_content feed.title
    end

    it "should show second feeds" do
      sign_in
      user = User.find_by_nickname("cola_zero")
      feed1 = Factory(:feed)
      feed2 = Factory(:feed)
      manager.register_user(feed1, user)
      manager.register_user(feed2, user)
      visit feeds_path
      page.must_have_content feed1.title
      page.must_have_content feed2.title
    end

    it "should not show different users feeds" do
      sign_in
      user = User.find_by_nickname("cola_zero")
      different_user = Factory(:user)
      feed1 = Factory(:feed)
      feed2 = Factory(:feed)
      manager.register_user(feed1, user)
      manager.register_user(feed2, different_user)
      visit feeds_path
      page.wont_have_content feed2.title
      page.wont_have_content feed2.url
    end
  end

  describe "/feeds/new" do
    before (:each) do
      visit '/auth/twitter'
    end

    it "should success" do
      visit new_feed_path
      page.must_have_selector "h1"
      page.must_have_content "Podcastfarm"
    end

    context "when valid url is given" do
      it "should create new feeds" do
        visit new_feed_path
        page.fill_in "feed_url", :with => valid_url
        page.click_button "Save"
        page.must_have_content "Feed was successfully created."
      end

      it "should show users feed list" do
        visit new_feed_path
        page.fill_in "feed_url", :with => valid_url
        page.click_button "Save"
        visit feeds_path
        page.must_have_content "Example Feed"
      end
    end

    context "when non valid url is given" do
      it "should not save new feeds" do
        visit new_feed_path
        page.fill_in "feed_url", :with => "asdfg"
        page.click_button "Save"
        page.must_have_content "Url given url is invalid"
      end
    end
  end

  describe "destroy feed", :js => true do
    before (:each) do
      sign_in
      visit new_feed_path
      page.fill_in "feed_url", :with => valid_url
      page.click_button "Save"
      visit feeds_path
    end

    it "should delete feed" do
      handle_js_confirm (true)do
        page.click_link "Destroy"
        page.wont_have_content "Example Feed"
      end
    end
  end

  describe "GET /feeds/1" do
    def sign_in_and_save_feed
      sign_in
      visit new_feed_path
      page.fill_in "feed_url", :with => valid_url
      page.click_button "Save"
    end

    it "should show title and url" do
      sign_in_and_save_feed
      visit feeds_path
      page.click_link "Show"
      page.must_have_content "Example Feed"
      page.must_have_content Feed.find_by_title("Example Feed").url
    end

    describe "GET /feeds/1/entries" do
      it "should show title of each entries" do
        sign_in_and_save_feed
        visit '/feeds/1/entries'
        (1..9).each do |n|
          page.must_have_content "Item##{n}"
        end
      end
    end

    describe "GET /feeds/1/entries/1" do
      it "should show title of entry." do
        sign_in_and_save_feed
        visit '/feeds/1/entries/1'
        page.must_have_content "Item#9"
      end

      it "should show enclosure url" do
        sign_in_and_save_feed
        visit '/feeds/1/entries/1'
        save_and_open_page
        page.must_have_content "http://example.com/ep9.mp4"
      end
    end
  end
end
