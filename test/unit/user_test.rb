# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  nickname   :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'test_helper'

describe User do

  describe "attributes" do
    let(:attr) { {
        'name'     => 'こーら',
        'nickname' => 'cola_zero'
      }}

    let(:user) { User.new(attr) }

    it 'must be valid' do
      user.must_be :valid?
    end

    context "when name is empty" do
      it "won't be valid" do
        attr.merge!('name' => "")
        user.wont_be :valid?
      end
    end

    context "when nickname is empty" do
      it "won't be valid" do
        attr.merge!('nickname' => "")
        user.wont_be :valid?
      end
    end
  end

  describe "authorization assosiation" do
    let(:user) { User.new }

    it "should respond to #authorizations" do
      user.must_respond_to :authorization
    end
  end

  describe 'find_or_create_from_hash method' do
    it 'should respond to .find_or_create_from_hash method' do
      User.must_respond_to :find_or_create_from_hash
    end

    let(:auth) { { 'provider' => 'twitter', 'uid' => 'asdfg',
        'info' => { 'name' => 'こーら', 'nickname' => 'cola_zero'} } }

    it 'must be silent' do
      lambda{ User.find_or_create_from_hash(auth) }.must_be_silent
    end

    describe "db access" do
      it "must create user instance" do
        before_count = User.count
        User.find_or_create_from_hash(auth)
        User.count.must_be_close_to before_count, 1
      end

      it"must create authorization instance" do
        before_count = Authorization.count
        User.find_or_create_from_hash(auth)
        Authorization.count.must_be_close_to before_count, 1
      end

      context 'adding authorization' do
        let(:user) { User.find_or_create_from_hash(auth)}

        before(:each) do
          @twitter_user = user
          @before_auth_count = Authorization.count
          @before_user_count = User.count
          auth.merge!({ 'provider' => 'facebook'})
          User.find_or_create_from_hash(auth, @twitter_user)
        end

        it 'should add authorization row in db' do
          Authorization.count.must_be_close_to @before_auth_count, 1
        end

        it 'should not add user row in db' do
          User.count.must_be_close_to @before_user_count, 1
        end
      end
    end

    describe "return value" do
      it "should return user instance" do
        User.find_or_create_from_hash(auth).must_be_kind_of(User)
      end

      it "should return user which name is 'こーら'" do
        User.find_or_create_from_hash(auth).name.must_equal 'こーら'
      end

      it "should return user which nickname is 'cola_zero'" do
        User.find_or_create_from_hash(auth).nickname.must_equal 'cola_zero'
      end

      context 'adding authorization' do
        let(:user) { User.find_or_create_from_hash(auth)}
        it "should return user when auth[:provider] is different" do
          auth.merge!({ 'provider' => 'facebook'})
          User.find_or_create_from_hash(auth, user).must_equal user
        end
      end

      context 'invalid auth hash' do
        context "when auth hash is nil" do
        it 'should return false' do
          User.find_or_create_from_hash(nil).must_equal false
          end
        end
      end
    end
  end

  describe 'create_from_hash method' do
    let(:auth) { { 'info' => { 'name' => 'こーら',
                            'nickname' => 'cola_zero'
        } } }
    it 'should respond_to .create_from_hash method' do
      User.must_respond_to(:create_from_hash)
    end

    it 'should return user instance when user found' do
      lambda{ User.create_from_hash(auth) }.must_be_silent
    end

    it 'should create user row in db' do
      before = User.count
      User.create_from_hash(auth)
      User.count.must_be_close_to(before, 1)
    end

        context "invalid auth hash" do
      context 'when name is empty' do
        it 'should return false' do
          auth.merge!({ 'info' => { 'name' => ''}})
          User.create_from_hash(auth).must_equal false
        end
      end
      context 'when nickname is empty' do
        it 'should return false' do
          auth.merge!({ 'info' => { 'nickname' => ''}})
          User.create_from_hash(auth).must_equal false
        end
      end
    end
  end
  describe "Feed association" do
    let(:auth) { { 'provider' => 'twitter', 'uid' => 'asdfg',
        'info' => { 'name' => 'こーら', 'nickname' => 'cola_zero'} } }
    subject { User.create_from_hash(auth) }
    it "must respond to feeds" do
      subject.must_respond_to :feeds
    end

    let(:url)  { "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "feed.rss"))}" }
    let(:user) { User.create_from_hash(auth)}
    let(:feed) { Feed.create( :url => url )}
    it "can access to feed" do
      feed.register_user(user)
      feed = Feed.find_by_url(url)
      user.feeds.must_equal([feed])
    end

    it "should add another feed" do
      feed1 = Feed.find_or_create_by_url(url)
      feed1.register_user(user)
      url = "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "first_feed.rss"))}"
      feed2 = Feed.find_or_create_by_url(url)
      feed2.register_user(user)
      user.feeds.must_equal([feed1, feed2])
    end
  end
end
