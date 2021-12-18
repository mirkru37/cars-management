# frozen_string_literal: true

module Filter
  class CarsFilter
    class << self
      # @param [Array<Car>] all_cars
      # @param [Array<SearchRule>] rules
      # @return [Array<Car>]
      def filter_by_rules(all_cars, rules)
        res = all_cars.clone
        rules.each do |rule|
          break if res.empty?

          res.filter! do |car|
            car.fit_rule?(rule)
          end
        end
        res
      end
    end
  end
end
