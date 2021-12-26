# frozen_string_literal: true

module Validation
  class SearchRule
    class << self
      # @param [Integer] max_year
      # @param [Integer] min_year
      # @return [Integer]
      def year(value, max_year: DateTime.now.year, min_year: 1800)
        return value if value.to_s.strip.empty?

        value = General.handle_int(value)
        General.handle_range(value, max_year, min_year)
        value
      end

      # @param [Float] max_price
      # @param [Float] min_price
      # @return [Float]
      def price(value, max_price: Float::MAX, min_price: 0)
        return value if value.to_s.strip.empty?

        value = General.handle_float(value)
        General.handle_range(value, max_price, min_price)
        value
      end
    end
  end
end
