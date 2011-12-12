require 'spec_helper'

describe "Feeds" do
  def valid_url
    "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "feed.rss"))}"
  end
  describe "GET /feeds" do
    it "should success" do
      visit feeds_path
      page.should have_selector "h1"
      page.should have_content "Podcastfarm"
    end

    it "should redirect sign in page and should sign in when not logged in" do
      visit feeds_path
      page.should have_content "cola_zero"
    end

    it "should show feeds" do
      visit "/auth/twitter"
      feed = Factory(:feed)
      feed.register_user(User.find_by_nickname("cola_zero"))
      visit feeds_path
      page.should have_content feed.title
    end

    it "should show second feeds" do
      visit "/auth/twitter"
      user = User.find_by_nickname("cola_zero")
      feed1 = Factory(:feed)
      feed2 = Factory(:feed)
      feed1.register_user(user)
      feed2.register_user(user)
      visit feeds_path
      page.should have_content feed1.title
      page.should have_content feed2.title
    end

    it "should not show different users feeds" do
      visit "/auth/twitter"
      user = User.find_by_nickname("cola_zero")
      different_user = Factory(:user)
      feed1 = Factory(:feed)
      feed2 = Factory(:feed)
      feed1.register_user(user)
      feed2.register_user(different_user)
      visit feeds_path
      page.should_not have_content feed2.title
      page.should_not have_content feed2.url
    end
  end

  describe "/feeds/new" do
    before do
      visit '/auth/twitter'
    end

    it "should success" do
      visit new_feed_path
      page.should have_selector "h1"
      page.should have_content "Podcastfarm"
    end

    context "when valid url is given" do
      it "should create new feeds" do
        visit new_feed_path
        page.fill_in "feed_url", :with => valid_url
        page.click_button "Save"
        page.should have_content "Feed was successfully created."
      end

      it "should show users feed list" do
        visit new_feed_path
        page.fill_in "feed_url", :with => valid_url
        page.click_button "Save"
        visit feeds_path
        page.should have_content "Example Feed"
      end
    end

    context "when non valid url is given" do
      it "should not save new feeds" do
        visit new_feed_path
        page.fill_in "feed_url", :with => "asdfg"
        page.click_button "Save"
        page.should have_content "Url given url is invalid"
      end
    end
  end

  describe "destroy feed", :js => true do
    before do
      visit '/auth/twitter'
      visit new_feed_path
      page.fill_in "feed_url", :with => valid_url
      page.click_button "Save"
      visit feeds_path
    end

    it "should delete feed" do
      handle_js_confirm (true)do
        page.click_link "Destroy"
        page.should_not have_content "Example Feed"
      end
    end
  end
end
