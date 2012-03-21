# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  nickname   :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
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
    name
    nickname
  end
end
