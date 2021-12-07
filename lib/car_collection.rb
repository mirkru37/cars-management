require 'date'

class CarCollection
  attr_reader :max_attr_len

  # @param [Array<Hash>]
  def initialize(all_cars = [])
    @all_cars = []
    @max_attr_len = 0
    append(all_cars) if all_cars
  end

  # @param [String] id
  def id?(id)
    @all_cars.any? { |car| car.id.casecmp?(id) }
  end

  # @param [Car] car
  def append_cars(car)
    raise ArgumentError, "There already is object with id #{car.id}" if id?(car.id)

    max_attr_len =  car.max_attr_len
    @max_attr_len = max_attr_len if @max_attr_len < max_attr_len
    @all_cars << car
  end

  # @param [Hash] car
  def append_hash(car)
    append_cars(Car.new(*car.values))
  end

  # @param [Array<Hash>] cars
  def append_array_hash(cars)
    cars.each do |car|
      append_hash(car)
    end
  end

  # @param [Array<Car>] cars
  def append_array_car(cars)
    cars.each do |car|
      append_cars(car)
    end
  end

  # @param [Array<Hash>, Array<Car>] cars
  def append_array(cars)
    if cars.all? { |obj| obj.instance_of?(Hash) }
      append_array_hash(cars)
    elsif cars.all? { |obj| obj.instance_of?(Car) }
      append_array_car(cars)
    else
      raise ArgumentError, 'Invalid array members!'
    end
  end

  # @param [Car, Hash, Array<Hash>, Array<CarAdv>]
  def append(cars)
    if cars.instance_of?(Car)
      append_cars(cars)
    elsif cars.instance_of?(Hash)
      append_hash(cars)
    elsif cars.instance_of?(Array)
      append_array(cars)
    else
      raise ArgumentError, 'Invalid argument!'
    end
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

  def all
    @all_cars
  end

  # @param [Car, Hash, Array<Hash>, Array<Car>] cars
  def <<(cars)
    append(cars)
  end
end
