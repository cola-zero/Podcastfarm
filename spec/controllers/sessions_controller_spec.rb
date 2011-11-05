require 'spec_helper'

describe SessionsController do
  describe "Get 'create'" do
    it 'should be success' do
      get 'create'
      response.should redirect_to '/'
    end
  end
end
