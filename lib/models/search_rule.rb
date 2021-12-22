# frozen_string_literal: false

require 'date'
require './lib/validation/search_rule'
require './lib/models/inputable'
require './lib/modules/hashify'

module Models
  class SearchRule < Inputable
    include Hashify

    # @param [String] name
    # @param [Integer] max_year
    # @param [Integer] min_year
    def self.year(name, max_year: DateTime.now.year, min_year: 1800)
      SearchRule.new(name,
                     validation_method: Validation::SearchRule.method(:year),
                     validation_parameters: { max_year: max_year, min_year: min_year })
    end

    # @param [String] name
    # @param [Integer] max_price
    # @param [Integer] min_price
    def self.price(name, max_price: Float::MAX, min_price: 0)
      SearchRule.new(name,
                     validation_method: Validation::SearchRule.method(:price),
                     validation_parameters: { max_price: max_price, min_price: min_price })
    end

    # @param [String] name
    # @param [Method] validation_method
    # @param [Hash] validation_parameters
    def initialize(name, validation_method: nil, validation_parameters: {})
      @validation_method = validation_method
      @validation_parameters = validation_parameters
      super(name)
    end

    # @param [String] new_val
    def value=(new_val)
      super @validation_method.nil? ? new_val : @validation_method.call(new_val, **@validation_parameters)
      @value.capitalize! if @value.instance_of?(String)
    end

    # override from Hashify to ignore specific fields
    def ivars_excluded_from_hash
      %w[@validation_method @validation_parameters]
    end
  end
end
