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

    def update_feed
      return false unless @parser.respond_to?(:entries)
      @parser.entries.each do |item_parser|
        entry = Entry.in_this_feed(self.id).find_from_parser(item_parser).first
        entry = Entry.new if entry == nil
        entry.get_entry_information(item_parser)
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
