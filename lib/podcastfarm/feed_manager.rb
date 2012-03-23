module Podcastfarm
  class FeedManager

    def self.find_or_create_feed ( url )
      feed = Feed.find_by_url(url)
      return feed unless feed == nil
      feed = Feed.new
      feed.get_feed_infomation(url)
      return feed
    end

    def self.register_user( feed, user)
      users = feed.users
      users << user unless users.include?(user)
      return users
    end

    def self.unregister_user( feed, user)
      feed.users.delete(user) if feed.users.include?(user)
      user.feeds.delete(feed) if user.feeds.include?(feed)
    end

    def self.update_feed(url)
      return false if url == nil
      feed = Feed.find_by_url(url.to_s)
      return false if feed == nil
      feed.update_feed
      return true
    end
  end
end
