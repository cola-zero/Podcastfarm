require 'test_helper'
SimpleCov.command_name 'test:inegration' if ENV["COVERAGE"]

describe "Authenticate Integration" do
  describe "sign in" do

    context "when success" do
      before(:each) do
        set_omniauth_mock
      end

      it "should sign in" do
        visit "/auth/twitter"
        page.must_have_content "Sign in."
      end

      it "should sign in with valid user" do
        visit "/auth/twitter"
        page.must_have_content "cola_zero"
      end
    end

    context "when auth fail" do
      before (:each) do
        set_omniauth_mock :invalid => true
      end
      it "should not sign in" do
        visit "/"
        visit "/auth/twitter"
        page.wont_have_content "cola_zero"
      end

      it "should show message" do
        visit "/auth/twitter"
        page.must_have_content "invalid_credentials"
      end
    end
  end
end
