require './lib/search'
require './lib/car_collection'
require './lib/hashify'

class SearchCollection
  include Hashify

  attr_reader :searches

  # @param [Array<Hash>, Array<Search>, Hash, Search, nil] searches
  def initialize(searches)
    @searches = []
    append(searches) unless searches.nil?
  end

  # @param [Search] search
  def append_search(search)
    if include?(search)
      i = index(search)
      search.request_quantity = @searches[i].request_quantity + 1
      @searches[i] = search
    else
      @searches << search
    end
  end

  # @param [Hash] search
  def append_hash(search)
    append_search(Search.new(*search.values))
  end

  # @param [Array<Hash>] searches
  def append_array_hash(searches)
    searches.each do |search|
      append_hash(search)
    end
  end

  # @param [Array<Search>] searches
  def append_array_search(searches)
    searches.each do |search|
      append_search(search)
    end
  end

  # @param [Array<Hash>, Array<Search>] searches
  def append_array(searches)
    if searches.all? { |obj| obj.instance_of?(Hash) }
      append_array_hash(searches)
    elsif searches.all? { |obj| obj.instance_of?(Search) }
      append_array_search(searches)
    else
      raise ArgumentError, 'Invalid array members!'
    end
  end

  # @param [Array<Hash>, Array<Search>, Hash, Search] searches
  def append(searches)
    if searches.instance_of?(Search)
      append_search(searches)
    elsif searches.instance_of?(Hash)
      append_hash(searches)
    elsif searches.instance_of?(Array)
      append_array(searches)
    else
      raise ArgumentError, 'Invalid argument!'
    end
  end

  # @param [Search] value
  # @return [TrueClass, FalseClass]
  def include?(value)
    @searches.any? do |search|
      search.equal_rules?(value.rules)
    end
  end

  # @param [Search] other
  def index(other)
    @searches.index do |search|
      search.equal_rules?(other.rules)
    end
  end

  def <<(searches)
    append(searches)
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
