class FeedsController < ApplicationController
  def show
    @feeds = Feed.all
  end
end
