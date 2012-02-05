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

class Subscription < ActiveRecord::Base

  attr_accessible :user_id
  attr_accessible :feed_id

  belongs_to :user
  belongs_to :feed
end
