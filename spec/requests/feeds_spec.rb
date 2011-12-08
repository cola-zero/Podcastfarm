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
  end
end
