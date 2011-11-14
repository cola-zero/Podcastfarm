# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)     not null
#  nickname   :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
  describe "attributes" do
    let(:attr) { { 
        :name     => 'こーら',
        :nickname => 'cola_zero'
      } }
    let(:user) { User.new(attr) }

    it 'should be valid' do
      user.should be_valid
    end

    context "name is empty" do
      it 'should not be valid' do
        attr.merge!(:name => "")
        user.should_not be_valid
      end
    end

    context "nickname is empty" do
      it 'should not be valid' do
        attr.merge!(:nickname => "")
        user.should_not be_valid
      end
    end
  end

  describe 'authorization assosiation' do
    let(:user) { User.new() }
 
    it 'should respond to #authorizations' do
      user.should respond_to(:authorization)
    end
  end

  describe 'sign_in_or_create_from_hash method' do
    it 'should respond to .sign_in_or_create_from_hash method' do
      User.should respond_to(:sign_in_or_create_from_hash)
    end

    let(:auth) { { :provider => 'twitter', :uid => 'asdfg',
        :info => { :name => 'こーら', :nickname => 'cola_zero'} } }
    it 'should not raise error' do
      lambda{ User.sign_in_or_create_from_hash(auth) }.should_not raise_error
    end

    describe "db access" do
      it 'should create user and instance' do
        lambda{ User.sign_in_or_create_from_hash(auth) }.should \
        change(User, :count).by(1)
      end

      it 'should create authorization instance' do
        lambda{ User.sign_in_or_create_from_hash(auth) }.should \
        change(User, :count).by(1)
      end
    end

    describe "return value" do
      it 'should return user instance' do
        User.sign_in_or_create_from_hash(auth).should == User.find(1)
      end
      it "should return user which name is 'こーら'" do
        User.sign_in_or_create_from_hash(auth).name.should == 'こーら'
      end
      it "should return user which nickname is 'cola_zero'" do
        User.sign_in_or_create_from_hash(auth).nickname.should == 'cola_zero'
      end

      context 'adding authorization' do
        let(:user) { User.sign_in_or_create_from_hash(auth)}
        it "should return user when auth[:provider] is different" do
          auth.merge!({ :provider => 'facebook'})
          User.sign_in_or_create_from_hash(auth, user).should == user
        end

        it 'should add authorization row in db' do
          auth.merge!({ :provider => 'facebook'})
          lambda{ User.sign_in_or_create_from_hash(auth, user)}.should \
          change(Authorization, :count).by(1)
        end
      end

      context 'invalid auth hash' do
        it 'should return false when auth is nil' do
          User.sign_in_or_create_from_hash(nil).should == false
        end
      end
    end
    
  end

  describe 'create_from_hash method' do
    let(:auth) { { :info => { :name => 'こーら',
                            :nickname => 'cola_zero'
        } } }
    it 'should respond_to .create_from_hash method' do
      User.should respond_to(:create_from_hash)
    end

    it 'should return user instance when user found' do
      lambda{ User.create_from_hash(auth) }.should_not raise_error
    end

    it 'should create user row in db' do
      lambda{ User.create_from_hash(auth) }.should change(User, :count).by(1)
    end
  end
end
