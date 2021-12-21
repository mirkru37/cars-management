# frozen_string_literal: true

class SearchCounter
  class << self
    # @param [Array<Search>] searches
    # @param [Search] search
    # @return [Integer]
    def call(searches, search)
      i = Controller::Searches.index(searches, search)
      return search.request_quantity if i.nil?

      search.request_quantity + searches[i].request_quantity
    end
  end
end
