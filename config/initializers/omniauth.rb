Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production? or Rails.env.staging?
    provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_SECRET_KEY'],
    {:client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
  else
    provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_SECRET_KEY']
  end
end
