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
  
  # @param [Array<Hash>, Array<SearchRule>] other
  # @return [TrueClass, FalseClass]
  def equal_rules?(other)
    return other.empty? if @rules.empty?
    return false if other.length != @rules.length

    @rules.all? do |rule|
      i = other.index do |other_rule|
        other_rule.to_hash['name'].casecmp(rule.to_hash['name'])
      end
      return false if i.nil?

      other[i].to_hash['value'] == rule.to_hash['value']
    end
  end
end
