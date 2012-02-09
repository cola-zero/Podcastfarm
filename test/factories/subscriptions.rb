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

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    folder_id 1
    feed_id 1
  end
end
