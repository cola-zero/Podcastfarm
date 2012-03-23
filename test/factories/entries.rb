# == Schema Information
#
# Table name: entries
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :string(255)
#  feed_id     :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  guid        :string(255)
#  enc_url     :string(255)
#  enc_length  :integer
#  enc_type    :string(255)
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entry do
    title "MyString"
    description "MyString"
    guid "asdfg"
    feed_id 1
  end

  factory :entry_in_another_feed, :parent => :entry do
    title "Entry2"
    description "Entry in another feed"
    guid "123456"
    feed_id 2
  end
end
