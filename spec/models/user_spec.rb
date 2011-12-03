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
        'name'     => 'こーら',
        'nickname' => 'cola_zero'
      } }
    let(:user) { User.new(attr) }

    it 'should be valid' do
      user.should be_valid
    end

    context "name is empty" do
      it 'should not be valid' do
        attr.merge!('name' => "")
        user.should_not be_valid
      end
    end

    context "nickname is empty" do
      it 'should not be valid' do
        attr.merge!('nickname' => "")
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

  describe 'find_or_create_from_hash method' do
    it 'should respond to .find_or_create_from_hash method' do
      User.should respond_to(:find_or_create_from_hash)
    end

    let(:auth) { { 'provider' => 'twitter', 'uid' => 'asdfg',
        'info' => { 'name' => 'こーら', 'nickname' => 'cola_zero'} } }
    it 'should not raise error' do
      lambda{ User.find_or_create_from_hash(auth) }.should_not raise_error
    end

    describe "db access" do
      it 'should create user and instance' do
        lambda{ User.find_or_create_from_hash(auth) }.should \
        change(User, :count).by(1)
      end

      it 'should create authorization instance' do
        lambda{ User.find_or_create_from_hash(auth) }.should \
        change(User, :count).by(1)
      end

      context 'adding authorization' do
        let(:user) { User.find_or_create_from_hash(auth)}
        it 'should add authorization row in db' do
          twitter_user = user #create User with twitter
          auth.merge!({ 'provider' => 'facebook'})
          lambda{ User.find_or_create_from_hash(auth, twitter_user)}.should \
          change(Authorization, :count).by(1)
        end
        it 'should not add user row in db' do
          twitter_user = user #create User with twitter
          auth.merge!({ 'provider' => 'facebook'})
          lambda{ User.find_or_create_from_hash(auth, twitter_user)}.should \
          change(User, :count).by(0)
        end
      end
    end

    describe "return value" do
      it 'should return user instance' do
        User.find_or_create_from_hash(auth).should == User.find(1)
      end
      it "should return user which name is 'こーら'" do
        User.find_or_create_from_hash(auth).name.should == 'こーら'
      end
      it "should return user which nickname is 'cola_zero'" do
        User.find_or_create_from_hash(auth).nickname.should == 'cola_zero'
      end

      context 'adding authorization' do
        let(:user) { User.find_or_create_from_hash(auth)}
        it "should return user when auth[:provider] is different" do
          auth.merge!({ 'provider' => 'facebook'})
          User.find_or_create_from_hash(auth, user).should == user
        end
      end

      context 'invalid auth hash' do
        context "when auth hash is nil"
        it 'should return false' do
          User.find_or_create_from_hash(nil).should == false
        end
      end
    end
    
  end

  describe 'create_from_hash method' do
    let(:auth) { { 'info' => { 'name' => 'こーら',
                            'nickname' => 'cola_zero'
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

    context "invalid auth hash" do
      context 'when name is empty' do
        it 'should return false' do
          auth.merge!({ 'info' => { 'name' => ''}})
          User.create_from_hash(auth).should be_false
        end
      end
      context 'when nickname is empty' do
        it 'should return false' do
          auth.merge!({ 'info' => { 'nickname' => ''}})
          User.create_from_hash(auth).should be_false
        end
      end
    end
  end
  
  describe "Feed association" do
    let(:auth) { { 'provider' => 'twitter', 'uid' => 'asdfg',
        'info' => { 'name' => 'こーら', 'nickname' => 'cola_zero'} } }
    subject { User.create_from_hash(auth) }
    it { should respond_to(:feeds) }

    let(:url)  { "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "feed.rss"))}" }
    let(:user) { User.create_from_hash(auth)}
    it "can access to feed" do
      Feed.register_feed(url, user)
      feed = Feed.find_by_url(url)
      user.feeds.should eq([feed])
    end

    it "should add another feed" do
      Feed.register_feed(url, user)
      feed1 = Feed.find_by_url(url)
      url = "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "first_feed.rss"))}"
      Feed.register_feed(url, user)
      feed2 = Feed.find_by_url(url)
      user.feeds.should eq([feed1, feed2])
    end

  end
end
