# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  feed_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'test_helper'

describe Subscription do
  subject{ Subscription.new }
  it { subject.must_be :valid? }

  describe "User association" do
    it { subject.must_respond_to(:user) }
  end

  describe "Feed association" do
    it { subject.must_respond_to(:feed) }
  end

  describe "validation" do
    before do
      Subscription.create(:user_id => 1, :feed_id => 1)
    end

    it "must be unique" do
      Subscription.create(:user_id => 1, :feed_id => 1)
      Subscription.count.must_equal 1
    end

    it "must be able to add another user" do
      Subscription.create(:user_id => 2, :feed_id => 1)
      Subscription.count.must_equal 2
    end

    it "must be able to add another feed" do
      Subscription.create(:user_id => 1, :feed_id => 2)
      Subscription.count.must_equal 2
    end
  end
end
