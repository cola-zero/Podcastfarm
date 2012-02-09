# == Schema Information
#
# Table name: feeds
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  url         :string(255)     not null
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :title do |n|
    "Example feeds ##{n}"
  end

  sequence :url do |n|
    "http://example#{n}.com/feed.rss"
  end

  sequence :description do |n|
    "This is #{n}th feed."
  end

  factory :feed do
    title { Factory.next(:name) }
    url   { Factory.next(:url) }
    description { Factory.next(:nickname) }
  end
end