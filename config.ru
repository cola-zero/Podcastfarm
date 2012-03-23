# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Podcastfarm::Application

if Rails.env.development?
  require 'girl_friday/server'

  run Rack::URLMap.new \
    "/"       => Podcastfarm::Application,
    "/girl_friday" => GirlFriday::Server.new
end
