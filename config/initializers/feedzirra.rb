class Feedzirra::Parser::RSSEntry
  element 'enclosure', :value => :url, :as => :enc_url
  element 'enclosure', :value => :length, :as => :enc_length
  element 'enclosure', :value => :type, :as => :enc_type
end
