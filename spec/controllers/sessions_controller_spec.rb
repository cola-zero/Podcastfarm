require 'spec_helper'

describe SessionsController do
  describe "Get 'create'" do
    it 'should be success' do
      pending 'create User.find_or_create_from_hash method.'
      get 'create'
      response.should redirect_to '/'
    end
  end
end
