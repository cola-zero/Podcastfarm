module Podcastfarm
  module ItemMethods

    def get_item_information( parser )
      return if parser == nil
      self.title = parser.title
      self.description = parser.description
    end
  end
end
