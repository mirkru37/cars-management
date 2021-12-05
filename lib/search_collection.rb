require './lib/search'
require './lib/car_collection'
require './lib/hashify'

class SearchCollection
  include Hashify

  # @param [Array<Hash>, Search] searches
  def initialize(searches)
    @searches = []
    append(searches) unless searches.nil?
  end

  # @param [Array<Hash>, Search] searches
  def append(searches)
    if searches.instance_of?(Search)
      append_search(searches)
    elsif searches.instance_of?(Array)
      append_array_hash(searches)
    else
      raise ArgumentError, 'Invalid argument!'
    end
  end

  # @param [Hash] search
  def append_hash(search)
    append_search(Search.new(*search.values))
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

  # @param [Array<Hash>] searches
  def append_array_hash(searches)
    searches.each do |search|
      append_hash(search)
    end
  end

  # @param [Search] other
  def index(other)
    @searches.index do |search|
      search.equal_rules?(other.rules)
    end
  end

  # @param [Search] search
  def request_quantity_sum(search)
    i = index(search)
    return search.request_quantity if i.nil?

    search.request_quantity + @searches[i].request_quantity
  end

  # @param [Integer] idn
  def [](idn)
    @searches[idn]
  end

  # @param [Integer] idn
  # @param [Search] val
  def []=(idn, val)
    @searches[idn] = val
  end
end
