# frozen_string_literal: true

class SearchCounter
  class << self
    # @param [SearchCollection] searches
    # @param [Search] search
    # @return [Integer]
    def call(searches, search)
      i = searches.index(search)
      return search.request_quantity if i.nil?

      search.request_quantity + searches[i].request_quantity
    end
  end
end
