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

  private

  def get_feed_infomation
    @feed_parser = make_parser
    if @feed_parser == 0 || @feed_parser == nil || @feed_parser == {}
      self.title = ""
      self.description = ""
    else
      self.title = @feed_parser.title || ""
      self.description = @feed_parser.description || ""
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
      %[http file feed].include?(URI.parse(self.url).scheme)
      rescue URI::InvalidURIError
        return false
    end
    return true
  end
end
