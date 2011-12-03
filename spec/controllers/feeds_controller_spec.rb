require 'spec_helper'

describe FeedsController do
  describe "Get show" do
    it 'should be success' do
      get :show
      response.should be_success
    end

    it 'should render the show templates' do
      get :show
      response.should render_template("show")
    end

    it 'asigns @feeds as all feeds' do
      @feeds = Factory(:feed)
      get :show
      assigns(:feeds).should eq([@feeds])
    end

    # it "should not show defferent user's feed" do
    #   feeds = [Factory(:feed)]
    #   feeds << Factory(:feed)
    #   user1 = Factory(:user)
    #   user2 = Factory(:user)
    #   Feed.
    # end
  end
end
