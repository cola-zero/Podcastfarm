# == Schema Information
#
# Table name: entries
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :string(255)
#  feed_id     :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  guid        :string(255)
#  enc_url     :string(255)
#  enc_length  :integer
#  enc_type    :string(255)
#

require 'entry_methods'

class Entry < ActiveRecord::Base
  include Podcastfarm::EntryMethods

  belongs_to :feed

  scope :in_this_feed, lambda { |f| where(:feed_id => f) }
  scope :find_from_parser, lambda { |p| where(:guid => p.id) }
end
