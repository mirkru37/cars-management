require './lib/hashify'

class Search
  include Hashify

  attr_accessor :total_quantity, :request_quantity, :rules, :result

  # @param [Integer] total_quantity
  # @param [Integer] request_quantity
  # @param [Array<SearchRule>] rules
  # @param [Array<Car>] result
  def initialize(total_quantity = 0, request_quantity = 1, rules = [], result = [])
    @total_quantity = total_quantity
    @request_quantity = request_quantity
    @rules = rules
    @result = result
  end

  # @param [Search] other
  # @return [TrueClass, FalseClass]
  def eql?(other)
    @total_quantity.eql?(other.total_quantity) && @request_quantity.eql?(other.request_quantity) && @rules.eql?(rules)
  end

  # @param [Hash, Search] other
  # @return [TrueClass, FalseClass]
  def equal?(other)
    other = Search.new(*other.values) if other.is_a?(Hash)
    eql?(other)
  end
end
