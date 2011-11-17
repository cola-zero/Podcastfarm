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
  factory :user do
    name "こーら"
    nickname "cola_zero"
  end
end
