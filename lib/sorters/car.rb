# frozen_string_literal: true

module Sorters
  class Car
    class << self
      # @param [Array<Car>] cars
      # @param [String] sort_by
      # @param [String] sort_order
      # @return [Array<Car>]
      def sort(cars, sort_by: 'date_added', sort_order: 'desc')
        sorted = cars.sort_by do |car|
          car.instance_variable_get("@#{sort_by}")
        end
        sort_order == 'desc' ? sorted.reverse : sorted
      end
    end
  end
end
