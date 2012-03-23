FEED_UPDATE_QUEUE = GirlFriday::WorkQueue.new(:update_feed, :size => 2) do |msg|
  Podcastfarm::FeedManager.update_feed(msg)
end
