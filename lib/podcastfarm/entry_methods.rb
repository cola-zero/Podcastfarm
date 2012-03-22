module Podcastfarm
  module EntryMethods

    def get_entry_information( parser )
      return if parser == nil
      self.title = parser.title
      self.description = parser.summary
      self.guid = parser.id
      self.enc_url = parser.enc_url
      self.enc_length = parser.enc_length.to_i
      self.enc_type = parser.enc_type
      save
    end
  end
end
