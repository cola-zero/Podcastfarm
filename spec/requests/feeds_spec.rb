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
  end
end
