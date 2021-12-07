require './lib/search'
require './lib/hashify'

class SearchCollection
  include Hashify

  # @param [Array<Hash>] searches
  def initialize(searches)
    @searches = init_searches(searches)
  end

  # @param [Search] search
  def append(search)
    i = index(search)
    if i.nil?
      @searches << search
    else
      @searches[i] = search
    end
  end

  # @param [Search] other
  def index(other)
    @searches.index do |search|
      search.equal_rules?(other.rules)
    end
  end

  # @param [Integer] idn
  # @return [Search]
  def [](idn)
    @searches[idn]
  end

  private

  # @param [Array<Hash>] searches
  def init_searches(searches)
    searches.map do |search|
      search['rules'].map! do |rule|
        rule_ = SearchRule.new(rule['name'])
        rule_.value = rule['value']
        rule_
      end
      new_search = Search.new(*search.values)
      new_search
    end
  end
end
