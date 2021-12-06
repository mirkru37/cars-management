require './lib/search'
require './lib/car_collection'
require './lib/hashify'

class SearchCollection
  include Hashify

  # @param [Array<Hash>] searches
  def initialize(searches)
    @searches = []
    append(searches) unless searches.empty?
  end

  # @param [Array<Hash>] searches
  def append(searches)
    searches.each do |search|
      append_hash(search)
    end
  end

  # @param [Hash] search
  def append_hash(search)
    new_search = Search.new(*search.values)
    append_search(new_search)
  end

  # @param [Search] search
  def append_search(search)
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
end
