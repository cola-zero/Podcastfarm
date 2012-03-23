require 'test_helper'
SimpleCov.command_name 'test:functionals' if ENV["COVERAGE"]

describe PagesController do

  tests PagesController

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.must_be :success?
    end
  end

end
