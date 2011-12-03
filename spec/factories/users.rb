# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)     not null
#  nickname   :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :name do |n|
    "MyName#{n}"
  end

  sequence :nickname do |n|
    "nickname#{n}"
  end

  factory :user do
    name { Factory.next(:name) }
    nickname { Factory.next(:nickname) }
  end
end
