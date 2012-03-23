# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: authorizations
#
#  id         :integer         not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'test_helper'
SimpleCov.command_name 'test:units' if ENV["COVERAGE"]

describe Authorization do

  describe "attributes" do
    let(:attr) { {
        :provider => 'twitter',
        :uid => 'asdfg',
        :user_id => 42
      }}
    let(:authorization) { Authorization.new }

    it "should not be valid" do
      authorization.wont_be :valid?
    end

    context "provider is empty" do
      it "should not be valid" do
        attr.merge!(:provider => "")
        authorization.wont_be :valid?
      end
    end

    context "uid is empty" do
      it "should not be valid" do
        attr.merge!(:uid => "")
        authorization.wont_be :valid?
      end
    end

    context "user_id is empty" do
      it "should not be valid" do
        attr.merge!(:user => nil)
        authorization.wont_be :valid?
      end
    end
  end

  describe "user association" do
    let(:authorization) { Authorization.new() }
    it 'should respond to user method' do
      authorization.must_respond_to(:user)
    end
  end

  describe "create_from_hash method" do
    it 'should respond to create_from_hash' do
      Authorization.must_respond_to(:create_from_hash)
    end
    let(:auth) { { 'provider' => 'twitter', 'uid' => 'asdfg'} }

    it 'should not raise error' do
      lambda{ Authorization.create_from_hash(auth, nil) }.must_be_silent
    end

    describe "invalid auth hash" do
      context "when provider is empty" do
        let(:user) { Factory(:user) }
        it 'should return false' do
          auth.merge!({ 'provider' => "" })
          Authorization.create_from_hash(auth, user).must_equal false
        end
      end
      context "when uid is empty" do
        let(:user) { Factory(:user) }
        it 'should return false' do
          auth.merge!({ 'uid' => "" })
          Authorization.create_from_hash(auth, user).must_equal false
        end
      end

      context "when user is not given" do
        context "and only name is given" do
          it "should return false" do
            auth.merge!({ 'info' => { 'name' => 'こーら' }} )
            Authorization.create_from_hash(auth).must_equal false
          end
        end
        context "and only nickname is given" do
          it "should return false" do
            auth.merge!({ 'info' => { 'nickname' => 'cola_zero' }} )
            Authorization.create_from_hash(auth).must_equal false
          end
        end
      end

    end

    context "with User instance" do
      let(:user) { Factory(:user) }

      it "should return authorized user" do
        Authorization.create_from_hash(auth, user).must_be_kind_of Authorization
      end

      it 'should create authorization row in db' do
        before = Authorization.count
        Authorization.create_from_hash(auth, user)
        Authorization.count.must_be_close_to(before, 1)
      end

      it 'should not create User row in db' do
        user
        auth.merge!( { 'info' => { 'name' => 'こーら', 'nickname' => 'cola_zero' } } )
        before = User.count
        Authorization.create_from_hash(auth, user)
        User.count.must_be_close_to(before, 0)
      end

      it 'should add another Authorization row' do
        user
        Authorization.create_from_hash(auth, user)
        before = Authorization.count
        auth.merge!({ 'provider' => 'facebook', 'uid' => '12345'})
        Authorization.create_from_hash(auth, user)
        Authorization.count.must_be_close_to(before, 1)
      end

    end

    context "without User instance" do
      it 'should create authorization row in db' do
        auth.merge!( { 'info' => { 'name' => 'こーら', 'nickname' => 'cola_zero' } } )
        before = Authorization.count
        Authorization.create_from_hash(auth, nil)
        Authorization.count.must_be_close_to(before,1)
      end

      it 'should create User row in db' do
        auth.merge!( { 'info' => { 'name' => 'こーら', 'nickname' => 'cola_zero' } } )
        before = User.count
        Authorization.create_from_hash(auth, nil)
        User.count.must_be_close_to(before,1)
      end
    end

  end

  describe "find_from_hash method" do
    it 'should respond to find_from_method' do
      Authorization.must_respond_to(:find_from_hash)
    end

    let(:auth) { { 'provider' => 'twitter', 'uid' => 'asdfg'} }
    let(:user) { Factory(:user) }

    it 'should return authorization instance' do
      Authorization.create_from_hash(auth, user)
      Authorization.find_from_hash(auth).must_equal Authorization.first
      Authorization.find_from_hash(auth).provider.must_equal 'twitter'
      Authorization.find_from_hash(auth).uid.must_equal 'asdfg'
    end

    context 'if auth has different provider' do
      it 'should return nil' do
        Authorization.create_from_hash(auth.merge({ 'provider' => 'facebook'}), user)
        Authorization.find_from_hash(auth).must_equal nil
      end
    end

    context 'if auth has different uid' do
      it 'should return nil' do
        Authorization.create_from_hash(auth.merge({ 'uid' => '123456'}), user)
        Authorization.find_from_hash(auth).must_equal nil
      end
    end

    context 'if auth is nil' do
      it 'should return false' do
        Authorization.find_from_hash(nil).must_equal false
      end
    end
  end
end
