# frozen_string_literal: true

module Operations
  class Car
    class << self
      # @param [Array<Hash>] cars
      def init_cars_array(cars)
        cars.map do |car|
          Models::Car.new(**car)
        end
      end

      # @param [Array<Car>] cars
      # @return [Integer]
      def max_attr_len(cars)
        max_len = cars.max_by(&:max_attr_len)
        max_len.nil? ? 0 : max_len.max_attr_len
      end
    end
  end
end
