require 'spec_helper'

describe "Authenticate" do
  describe "sign in" do
    before(:each) do
      set_omniauth_mock
    end

    it "should sign in" do
      visit "/auth/twitter"
      page.should have_content "Sign in."
    end

    it "should sign in with valid user" do
      visit "/auth/twitter"
      page.should have_content "cola_zero"
    end

    context "when auth fail" do
      before (:each) do
        set_omniauth_mock :invalid => true
      end
      it "should not sign in" do
        visit "/auth/twitter"
        page.should_not have_content "cola_zero"
      end

      it "should show message" do
        visit "/auth/twitter"
        page.should have_content "invalid_credentials"
      end
    end
  end
end
