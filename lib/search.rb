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

  # @param [Array<SearchRule>] other_rules
  # @return [TrueClass, FalseClass]
  def equal_rules?(other_rules)
    return other_rules.empty? if @rules.empty?
    return false if other_rules.length != @rules.length

    @rules.all? do |rule|
      contains?(other_rules, rule)
    end
  end

  private

  # @param [Array<SearchRule>] rules_arr
  # @param [SearchRule] rule
  # @return [TrueClass, FalseClass]
  def equal?(rules_arr, rule)
    i = rules_arr.index { |other_rule| other_rule.name == rule.name }
    return false if i.nil?

    rule.value.instance_of?(String) ? rules_arr[i].value.casecmp(rule.value).zero? : rules_arr[i].value == rule.value
  end
end
