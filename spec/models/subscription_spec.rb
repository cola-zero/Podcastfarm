# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  feed_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Subscription do
  subject{ Subscription.new }
  it { should be_valid }

  describe "User association" do
    it { should respond_to(:user) }
  end

  describe "Feed association" do
    it { should respond_to(:feed) }
  end
end
