# frozen_string_literal: true

module Sorter
  class Cars
    class << self
      # @param [Array<Car>] all_cars
      # @param [String] sort_by
      # @param [String] sort_order
      # @return [Array<Car>]
      def sort(all_cars, sort_by: 'date_added', sort_order: 'desc')
        res = all_cars.clone
        res.sort_by! do |car|
          car.instance_variable_get("@#{sort_by}")
        end
        sort_order == 'desc' ? res.reverse! : res
      end
    end
  end
end
