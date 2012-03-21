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

require 'feed_methods'

class Feed < ActiveRecord::Base
  include ApplicationHelper
  include Podcastfarm::FeedMethods

  validates :url, :presence => true, :uniqueness => true
  validate :url_is_valid

  has_many :subscriptions
  has_many :users, :through => :subscriptions
  has_many :entries, :dependent => :destroy

end
