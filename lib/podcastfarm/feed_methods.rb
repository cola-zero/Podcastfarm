module Podcastfarm
  module FeedMethods
    def get_feed_infomation( feed_parser = nil)
      feed_parser ||= make_parser
      # feed_parser = make_parser
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
  end
end
