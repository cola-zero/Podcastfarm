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
        before do 
          OmniAuth.config.mock_auth[:twitter] = {
            'provider' => 'twitter',
            'uid' => '123545',
            'info' => { 'nickname' => 'cola_zero',
              'name' => 'こーら'}
          }
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
        before do
          OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
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
      before do
        OmniAuth.config.mock_auth[:twitter] = {
          'provider' => 'twitter',
          'uid' => '123545',
          'info' => { 'nickname' => 'cola_zero',
            'name' => 'こーら'}
          }
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter] 
      end

      it 'should be "Sign in."' do
        get 'create'
        controller.flash[:notice].should == 'Sign in.'
      end
    end
    
  end  
end
