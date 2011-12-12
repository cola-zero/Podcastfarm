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

class Feed < ActiveRecord::Base
  include ApplicationHelper
  validates :url, :presence => true, :uniqueness => true
  validate :url_is_valid

  before_validation :get_feed_infomation

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

  def get_feed_infomation
    @feed_parser = make_parser
    if @feed_parser.respond_to?(:title) && @feed_parser.respond_to?(:description)
      self.title = @feed_parser.title || ""
      self.description = @feed_parser.description || ""
    else
      self.title ||= ""
      self.description ||= ""
    end
  end

  def make_parser
    Feedzirra::Feed.fetch_and_parse(self.url)
  end

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
