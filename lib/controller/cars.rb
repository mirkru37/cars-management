# frozen_string_literal: true

module Controller
  class Cars
    class << self
      # @param [Array<Hash>] all_cars
      def init(all_cars)
        all_cars.map do |car|
          Car.new(**car)
        end
      end

      # @param [Array<Car>] all_cars
      # @return [Integer]
      def max_attr_len(all_cars)
        max_len = all_cars.max_by(&:max_attr_len)
        max_len.nil? ? 0 : max_len.max_attr_len
      end
    end
  end
end
