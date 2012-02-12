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
#  guid        :string(255)
#

require 'item_methods'

class Item < ActiveRecord::Base
  include Podcastfarm::ItemMethods

  belongs_to :feed

  scope :in_this_feed, lambda { |f| where(:feed_id => f) }
end
