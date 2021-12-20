# frozen_string_literal: true

module Filter
  class Cars
    class << self
      # @param [Array<Car>] cars
      # @param [Array<SearchRule>] rules
      # @return [Array<Car>]
      def filter_by_rules(cars, rules)
        cars.select do |car|
          rules.all? do |rule|
            car.fit_rule?(rule)
          end
        end
      end
    end
  end
end
