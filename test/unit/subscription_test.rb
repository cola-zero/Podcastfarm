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
end
