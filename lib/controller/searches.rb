# frozen_string_literal: true

module Controller
  class Searches
    class << self
      # @param [Array<Hash>] searches
      def init(searches)
        searches.map do |search|
          search['rules'].map! do |rule|
            rule_ = SearchRule.new(rule['name'])
            rule_.value = rule['value']
            rule_
          end
          Search.new(*search.values)
        end
      end

      # @param [Array<Search>] searches
      # @param [Search] other
      def index(searches, other)
        searches.index do |search|
          search.equal_rules?(other.rules)
        end
      end

      # @param [Array<Search>] searches
      # @param [Search] search
      def replace(searches, search)
        i = index(searches, search)
        searches[i] = search
      end
    end
  end
end
