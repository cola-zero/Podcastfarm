module Podcastfarm
  module EntryMethods

    def get_entry_information( parser )
      return if parser == nil
      self.title = parser.title
      self.description = parser.description
    end
  end
end
