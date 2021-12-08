# frozen_string_literal: true

require './lib/hashify'

class Search
  include Hashify

  attr_accessor :total_quantity, :request_quantity, :rules

  # @param [Integer] total_quantity
  # @param [Integer] request_quantity
  # @param [Array<SearchRule>] rules
  def initialize(total_quantity = 0, request_quantity = 1, rules = [])
    @total_quantity = total_quantity
    @request_quantity = request_quantity
    @rules = rules
  end

  # @param [Array<SearchRule>] other
  # @return [TrueClass, FalseClass]
  def equal_rules?(other)
    return other.empty? if @rules.empty?
    return false if other.length != @rules.length

    @rules.all? do |rule|
      i = other.index { |other_rule| other_rule.name == rule.name }
      return false if i.nil?

      rule.value.instance_of?(String) ? other[i].value.casecmp(rule.value).zero? : other[i].value == rule.value
    end
  end
end
