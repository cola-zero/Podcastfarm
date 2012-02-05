# -*- coding: utf-8 -*-
require 'spec_helper'

describe SessionsController do

  describe "Get 'create'" do
    it 'should be success' do
      # pending 'create User.find_or_create_from_hash method.'
      get 'create'
      response.should redirect_to '/'
    end

    describe 'login with twitter using omniauth' do
      context 'when success' do
        before (:each) do
          set_omniauth_mock
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        end

        it 'assign @current_user' do
          get 'create'
          assigns(:current_user).should be_a(User)
        end
        it 'assgin session[:user_id] to user_id' do
          get 'create'
          controller.session[:user_id].should == controller.current_user.id
        end
        describe "signed_in? helper method" do
          it 'should return true' do
            get 'create'
            controller.signed_in?.should be_true
          end
        end
      end

      context 'when fail' do
        before (:each) do
          set_omniauth_mock :invalid => true
        end
        it 'assign @current_user to nil' do
          get 'create'
          assigns(:current_user).should be_nil
        end
        it 'assign session[:user_id] to nil' do
          get 'create'
          controller.session[:user_id].should be_nil
        end
      end
    end
  end

  describe "flash messagegs" do
    context "when user sign in" do
      before (:each) do
        set_omniauth_mock
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      end

      it 'should be "Sign in."' do
        get 'create'
        controller.flash[:notice].should == 'Sign in.'
      end
    end

  end

  describe "DELETE 'destroy'" do
    before (:each) do
      controller.sign_in Factory(:user)
    end
    it 'should sign a user out' do
      delete 'destroy'
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end

    describe 'flash messaged' do
      it 'should be "Signed out."' do
        delete 'destroy'
        controller.flash[:notice].should == "Signed out."
      end
    end
  end

  describe "GET 'failure'" do
    it "should be redirect to root_path" do
      get 'failure'
      response.should redirect_to(root_path)
    end

    describe "flash messages" do
      it 'should show error messages' do
        params = { :message => 'invalid_credentials' }
        controller.stub!(:params).and_return ({ :message => 'invalid_credentials'})
        get 'failure'
        controller.flash[:notice].should == params[:message]
      end
    end
  end
end
