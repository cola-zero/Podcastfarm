# == Schema Information
#
# Table name: items
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :string(255)
#  feed_id     :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    title "MyString"
    description "MyString"
    feed_id 1
  end
end
