# == Schema Information
#
# Table name: feeds
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  url         :string(255)
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
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
    title
    url
    description
  end
end
