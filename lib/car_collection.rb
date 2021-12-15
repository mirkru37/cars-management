require 'date'

class CarCollection
  # @param [Array<Hash>, Array<Car>] all_cars
  def initialize(all_cars = [])
    @all_cars = init_cars(all_cars)
  end

  # @return [Array<Car>]
  def all
    @all_cars
  end

  # @param [Array<SearchRule>]
  # @return [Array<Car>]
  def filter_by_rules(rules)
    res = @all_cars.clone
    rules.each do |rule|
      break if res.empty?

      res.filter! do |car|
        car.fit_rule?(rule)
      end
    end
    res
  end

  # @return [Integer]
  def max_attr_len
    max_len = @all_cars.max_by(&:max_attr_len)
    max_len.nil? ? 0 : max_len.max_attr_len
  end

  # @param [String] sort_by
  # @param [String] sort_order
  # @return [Array<Car>]
  def sort(sort_by: 'date_added', sort_order: 'desc')
    res = @all_cars.clone
    res.sort_by! do |car|
      car.instance_variable_get("@#{sort_by}")
    end
    sort_order == 'desc' ? res.reverse! : res
  end

  private

  # @param [Array<Hash>, Array<Car>]
  def init_cars(all_cars)
    return all_cars if all_cars.all? { |car| car.instance_of?(Car) }

    all_cars.map do |car|
      Car.new(*car.values)
    end
  end
end
