require 'test_no_rails_helper'
SimpleCov.command_name 'test:units' if ENV["COVERAGE"]
require 'user_manager'


class User; end
class Authorization; end

describe Podcastfarm::UserManager do

  let(:manager) { Podcastfarm::UserManager }
  let(:auth_hash) {
    { 'provider' => 'twitter', 'uid' => 'asdfg',
      'info' => { 'name' => 'cola', 'nickname' => 'cola_zero' }
    }
  }
  let(:auth) { mock() }
  let(:user) { mock() }

  describe "find_from_hash method" do
    it "should respond to" do
      manager.must_respond_to(:find_from_hash)
    end

    it "should find valid user" do
      Authorization.expects(:find_from_hash).
        with(auth_hash).returns(auth)
      auth.expects(:user).returns(User.new)
      manager.find_from_hash(auth_hash).must_be_kind_of(User)
    end

    context "when auth not found" do
      it "should return false" do
        Authorization.expects(:find_from_hash).
          with(auth_hash).returns(false)
        manager.find_from_hash(auth_hash).must_equal false
      end
    end
  end

  describe "create_from_hash method" do
    it "should respond to" do
      manager.must_respond_to(:create_from_hash)
    end

    it "should create new user and auth model" do
      User.expects(:create_from_hash).with(auth_hash).returns(user)
      Authorization.expects(:create_from_hash).with(auth_hash, user).returns(auth)
      manager.create_from_hash(auth_hash).must_equal user
    end

    context "when authorization does not create" do
      it "should return false" do
        User.expects(:create_from_hash).with(auth_hash).returns(user)
        Authorization.expects(:create_from_hash).with(auth_hash, user).returns(false)
        manager.create_from_hash(auth_hash).must_equal false
      end
    end
  end

  describe "find_or_create_from_hash" do
    it "must_respond_to" do
      manager.must_respond_to(:find_or_create_from_hash)
    end

    context "when user exists" do
      it "should find user" do
        manager.expects(:find_from_hash).with(auth_hash).returns(user)
        manager.find_or_create_from_hash(auth_hash).must_equal user
      end
    end

    context "when user does not exist" do
      it "should create user" do
        manager.expects(:find_from_hash).with(auth_hash).returns(false)
        manager.expects(:create_from_hash).with(auth_hash).returns(user)
        manager.find_or_create_from_hash(auth_hash).must_equal user
      end
    end

    context "when auth_hash is nil" do
      it "should return false" do
        manager.find_or_create_from_hash(nil).must_equal false
      end
    end
  end

end
