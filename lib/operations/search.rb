# frozen_string_literal: true

module Operations
  class Search
    class << self
      # @param [Array<Hash>] searches
      def init_searches_array(searches)
        searches.map do |search|
          search['rules'].map! do |rule|
            rule_ = Models::SearchRule.new(rule['name'])
            rule_.value = rule['value']
            rule_
          end
          Models::Search.new(*search.values)
        end
      end

      # @param [Array<Search>] searches
      # @param [Search] search
      def append(searches, search)
        if search.request_quantity == 1
          searches << search
        else
          replace(searches, search)
        end
      end

      # @param [Array<Search>] searches
      # @param [Search] search
      # @return [Integer]
      def count(searches, search)
        i = index(searches, search)
        return search.request_quantity if i.nil?

        search.request_quantity + searches[i].request_quantity
      end

      # @param [Array<Search>] searches
      # @param [Search] other
      def index(searches, other)
        searches.index do |search|
          search.equal_rules?(other.rules)
        end
      end

      private

      # @param [Array<Search>] searches
      # @param [Search] search
      def replace(searches, search)
        i = index(searches, search)
        searches[i] = search
      end
    end
  end
end
