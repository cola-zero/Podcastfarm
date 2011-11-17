# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: authorizations
#
#  id         :integer         not null, primary key
#  provider   :string(255)     not null
#  uid        :string(255)     not null
#  user_id    :integer         not null
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Authorization do
  describe "attributes" do
    let(:attr) { { 
        :provider => 'twitter',
        :uid => 'asdfg',
        :user_id => 42
      }}
    let(:authorization) { Authorization.new(attr) }

    it "should be valid" do
      authorization.should be_valid
    end

    context "provider is empty" do
      it "should not be valid" do
        attr.merge!(:provider => "")
        authorization.should_not be_valid
      end
    end

    context "uid is empty" do
      it "should not be valid" do
        attr.merge!(:uid => "")
        authorization.should_not be_valid
      end
    end

    context "user_id is empty" do
      it "should not be valid" do
        attr.merge!(:user => nil)
        authorization.should_not be_valid
      end
    end
  end

  describe "user association" do
    let(:authorization) { Authorization.new() }
    it 'should respond to user method' do
      authorization.should respond_to(:user)
    end
  end

  describe "create_from_hash method" do
    it 'should respond to create_from_hash' do
      Authorization.should respond_to(:create_from_hash)
    end
    let(:auth) { { 'provider' => 'twitter', 'uid' => 'asdfg'} }

    it 'should not raise error' do
      lambda{ Authorization.create_from_hash(auth, nil) }.should_not raise_error
    end

    describe "invalid auth hash" do
      context "when provider is empty" do
        let(:user) { Factory(:user) }
        it 'should return false' do
          auth.merge!({ 'provider' => "" })
          Authorization.create_from_hash(auth, user).should == false
        end
      end
      context "when uid is empty"
      let(:user) { Factory(:user) }
      it 'should return false' do
        auth.merge!({ 'uid' => "" })
        Authorization.create_from_hash(auth, user).should == false
      end

      context "when user is not given" do
        context "and only name is given" do
          it "should return false" do
            auth.merge!({ 'info' => { 'name' => 'こーら' }} )
            Authorization.create_from_hash(auth).should == false
          end
        end
        context "and only nickname is given" do
          it "should return false" do
            auth.merge!({ 'info' => { 'nickname' => 'cola_zero' }} )
            Authorization.create_from_hash(auth).should == false
          end
        end
      end

    end

    context "with User instance" do
      let(:user) { Factory(:user) }
      it 'should create authorization row in db' do
        lambda{ Authorization.create_from_hash(auth, user) }.should \
        change(Authorization, :count).by(1)
      end

      it 'should not create User row in db' do
        user
        auth.merge!( { 'info' => { 'name' => 'こーら', 'nickname' => 'cola_zero' } } )
        lambda{ Authorization.create_from_hash(auth, user) }.should \
        change(User, :count).by(0)
      end

      it 'should add another Authorization row' do
        user
        Authorization.create_from_hash(auth, user)
        auth.merge!({ 'provider' => 'facebook', 'uid' => '12345'})
        lambda{ Authorization.create_from_hash(auth, user) }.should \
        change(Authorization, :count).by(1)
      end

    end

    context "without User instance" do
      it 'should create authorization row in db' do
        auth.merge!( { 'info' => { 'name' => 'こーら', 'nickname' => 'cola_zero' } } )
        lambda{ Authorization.create_from_hash(auth, nil) }.should \
        change(Authorization, :count).by(1)
      end

      it 'should create User row in db' do
        auth.merge!( { 'info' => { 'name' => 'こーら', 'nickname' => 'cola_zero' } } )
        lambda{ Authorization.create_from_hash(auth, nil) }.should \
        change(User, :count).by(1)
      end
    end

  end

  describe "find_from_hash method" do
    it 'should respond to find_from_method' do
      Authorization.should respond_to(:find_from_hash)
    end

    let(:auth) { { 'provider' => 'twitter', 'uid' => 'asdfg'} }
    let(:user) { Factory(:user) }

    it 'should return authorization instance' do
      Authorization.create_from_hash(auth, user)
      Authorization.find_from_hash(auth).should == Authorization.first
      Authorization.find_from_hash(auth).provider.should == 'twitter'
      Authorization.find_from_hash(auth).uid.should == 'asdfg'
    end

    context 'if auth has different provider' do
      it 'should return nil' do
        Authorization.create_from_hash(auth.merge({ 'provider' => 'facebook'}), user)
        Authorization.find_from_hash(auth).should == nil
      end
    end

    context 'if auth has different uid' do
      it 'should return nil' do
        Authorization.create_from_hash(auth.merge({ 'uid' => '123456'}), user)
        Authorization.find_from_hash(auth).should == nil
      end
    end

    context 'if auth is nil' do
      it 'should return false' do
        Authorization.find_from_hash(nil).should == false
      end
    end
  end
end
