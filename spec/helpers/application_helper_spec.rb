# -*- coding: utf-8 -*-
describe "ApplicationHelpers" do
  describe "current user" do
    context 'when user is not logged in' do
      it "should return nil when not logged in" do
        helper.current_user.should be_nil
      end
      
      it 'should be nil when session[:user_id] is not set' do
        Factory(:user)
        helper.current_user.should be_nil
      end
    end

    context "when user logged in" do
      it 'should return User' do
        user = Factory(:user)
        session[:user_id] = user.id
        helper.current_user.should be_a(User)
      end
      
      it 'should return right User' do
        user = Factory(:user)
        session[:user_id] = user.id
        helper.current_user.name.should == user.name
        helper.current_user.nickname.should == user.nickname
      end
    end
  end

  describe "sign_in" do
    it "should set current_user" do
      helper.sign_in Factory(:user)
      helper.current_user.should be_a(User)
    end

    it "should set user_id session valiable" do
      user = Factory(:user)
      helper.sign_in(user)
      session[:user_id].should == user.id
    end
  end

  describe "signed_in?" do
    context "when not signed in" do
      it "should return false" do
        helper.signed_in?.should be_false
      end
    end

    context "when signed in" do
      it "should return true" do
        user = Factory(:user)
        session[:user_id] = user.id
        helper.signed_in?.should be_true
      end
    end
  end

  describe "sign_out"  do
    before do
      helper.sign_in Factory(:user)
    end

    it "should set nil to current_user" do
      helper.sign_out
      helper.current_user.should be_nil
    end
  end
end
