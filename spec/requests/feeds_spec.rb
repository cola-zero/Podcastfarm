require 'spec_helper'

describe "Feeds" do
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
      save_and_open_page
      page.should_not have_content feed2.title
      page.should_not have_content feed2.url
    end
  end
end
