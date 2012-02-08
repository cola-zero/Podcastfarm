require 'test_helper'

describe "Feeds Integration" do
  # include TransactionalTests

  def valid_url
    "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "feed.rss"))}"
  end

  def sign_in
    visit "/auth/twitter"
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
      feed = Factory.create(:feed)
      feed.register_user(User.find_by_nickname("cola_zero"))
      visit feeds_path
      page.must_have_content feed.title
    end

    it "should show second feeds" do
      sign_in
      user = User.find_by_nickname("cola_zero")
      feed1 = Factory(:feed)
      feed2 = Factory(:feed)
      feed1.register_user(user)
      feed2.register_user(user)
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
      feed1.register_user(user)
      feed2.register_user(different_user)
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
    it "should show title and url" do
      sign_in
      visit new_feed_path
      page.fill_in "feed_url", :with => valid_url
      page.click_button "Save"
      visit feeds_path
      page.click_link "Show"
      page.must_have_content "Example Feed"
      page.must_have_content Feed.find_by_title("Example Feed").url
    end
  end
end
