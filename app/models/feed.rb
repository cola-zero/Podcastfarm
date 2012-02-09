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

  def register_user(user)
    return false unless user.respond_to?(:nickname)
    feed = Feed.find_or_create_by_url(url)
    feed.users << [user] unless feed.users.find_by_id(user.id)
  end

  def unregister_user(user)
    self.users.delete(user)
    user.feeds.delete(self)
  end

  private

  def url_is_valid
    valid_url? ? true : errors.add(:url, 'given url is invalid')
  end

  def valid_url?
    begin
      uri = URI.parse(self.url)
      rescue URI::InvalidURIError
        return false
    end
    if uri.scheme.nil? || !(%[http file feed].include?(uri.scheme))
      return false
    end
    return true
  end
end
