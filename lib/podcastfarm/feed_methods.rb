module Podcastfarm
  module FeedMethods
    def get_feed_infomation( url = nil )
      self.url ||= url
      make_parser
      if @parser.respond_to?(:title) && @parser.respond_to?(:description)
        self.title = @parser.title || ""
        self.description = @parser.description || ""
      else
        self.title ||= ""
        self.description ||= ""
      end
    end

    def make_item(item_parser)
      if item_parser.respond_to?(:title) && item_parser.respond_to?(:description)
        item = Item.new
        item.title = item_parser.title
        item.description = item_parser.description
        return item.save
      else
        return false
      end
    end

    def update_feed
      @parser.entries.each do |item_parser|
        make_item(item_parser)
      end
    end

    private

    def make_parser
      @parser ||= Feedzirra::Feed.fetch_and_parse(self.url)
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
end
