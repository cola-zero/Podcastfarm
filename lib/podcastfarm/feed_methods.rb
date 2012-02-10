module Podcastfarm
  module FeedMethods
    def get_feed_infomation( url = nil )
      self.url ||= url
      feed_parser ||= make_parser
      if feed_parser.respond_to?(:title) && feed_parser.respond_to?(:description)
        self.title = feed_parser.title || ""
        self.description = feed_parser.description || ""
      else
        self.title ||= ""
        self.description ||= ""
      end
    end


    private

    def make_parser
      Feedzirra::Feed.fetch_and_parse(self.url)
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
end
