require 'test_helper'
SimpleCov.command_name 'test:functionals' if ENV["COVERAGE"]

describe SessionsController do

  tests SessionsController

  describe "Get 'create'" do
    it 'should be success' do
      set_omniauth_mock
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      get 'create'
      assert_redirected_to '/'
    end

    describe 'login with twitter using omniauth' do
      context 'when success' do
        before (:each) do
          set_omniauth_mock
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        end

        it 'assign @current_user' do
          get 'create'
          assigns(:current_user).must_be_kind_of(User)
        end
        it 'assgin session[:user_id] to user_id' do
          get 'create'
          @controller.session[:user_id].must_equal @controller.current_user.id
        end
        describe "signed_in? helper method" do
          it 'should return true' do
            get 'create'
            @controller.signed_in?.must_equal true
          end
        end
      end

      context 'when fail' do
        before (:each) do
          set_omniauth_mock :invalid => true
        end
        it 'assign @current_user to nil' do
          get 'create'
          assigns(:current_user).must_equal nil
        end
        it 'assign session[:user_id] to nil' do
          get 'create'
          @controller.session[:user_id].must_equal nil
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
        @controller.flash[:notice].must_equal 'Sign in.'
      end
    end

  end

  describe "DELETE 'destroy'" do
    before (:each) do
      @controller.sign_in Factory(:user)
    end
    it 'should sign a user out' do
      delete 'destroy'
      @controller.wont_be :signed_in?
      assert_redirected_to(root_path)
    end

    describe 'flash messaged' do
      it 'should be "Signed out."' do
        delete 'destroy'
        @controller.flash[:notice].must_equal "Signed out."
      end
    end
  end

  describe "GET 'failure'" do
    it "should be redirect to root_path" do
      get 'failure'
      assert_redirected_to(root_path)
    end

    describe "flash messages" do
      it 'should show error messages' do
        params = { :message => 'invalid_credentials' }
        @controller.expects(:params).twice.returns ({ :message => 'invalid_credentials'})
        get 'failure'
        @controller.flash[:notice].must_equal params[:message]
      end
    end
  end
end
