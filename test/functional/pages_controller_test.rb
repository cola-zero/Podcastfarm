require 'test_helper'

describe PagesController do

  tests PagesController

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.must_be :success?
    end
  end

end
