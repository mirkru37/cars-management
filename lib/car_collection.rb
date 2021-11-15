require 'date'

class CarCollection

  def initialize
    @adv = []
  end

  # @param [String] id
  def id?(id)
    @adv.any? { |adv| adv.id.casecmp?(id) }
  end

  # @param [Car] data
  def append_adv(data)
    if id?(data.id)
      raise ArgumentError, "There already is object with id #{data.id}"
    else
      @adv << data
    end
  end

  # @param [Hash] data
  def append_hash(data)
    if id?(data[:id])
      raise ArgumentError, "There already is object with id #{data.id}"
    else
      @adv << Car.new(*data.values)
    end
  end

  # @param [Array<Hash>] data
  def append_array_hash(data)
    data.each do |hash|
      append_hash(hash)
    end
  end

  # @param [Array<Car>] data
  def append_array_adv(data)
    @adv += data
  end

  # @param [Array<Hash>, Array<Car>] data
  def append_array(data)
    if data.all? { |obj| obj.instance_of?(Hash) }
      append_array_hash(data)
    elsif data.all? { |obj| obj.instance_of?(Car) }
      append_array_adv(data)
    else
      puts data.inspect
      raise ArgumentError, 'Invalid array members!'
    end
  end

  # @param [Car, Hash, Array<Hash>, Array<CarAdv>]
  def append(data)
    if data.instance_of?(Car)
      append_adv(data)
    elsif data.instance_of?(Hash)
      append_hash(data)
    elsif data.instance_of?(Array)
      append_array(data)
    else
      raise ArgumentError, 'Invalid argument!'
    end
  end

  # @param [Array<SearchRule>]
  # @return [CarCollection]
  def filter_by_rules(rules)
    res = @adv.clone
    rules.each do |rule|
      break if res.empty?

      res.filter! do |adv|
        adv.fit_rule?(rule)
      end
    end
    CarCollection.hash_adv(res)
  end

  # @param [String] sort_by
  # @param [String] sort_order
  # @return [CarCollection]
  def sort(sort_by: 'date_added', sort_order: 'desc')
    res = @adv.clone
    res.sort_by! do |car|
      car.instance_variable_get("@#{sort_by}")
    end
    res.reverse! if sort_order == 'desc'
    CarCollection.hash_adv(res)
  end

  # @param [String] sort_by
  # @param [String] sort_order
  def sort!(sort_by: 'date_added', sort_order: 'desc')
    @adv = sort(sort_by: sort_by, sort_order: sort_order).all
  end

  def all
    @adv
  end

  # @param [Car, Hash, Array<Hash>, Array<Car>]
  def <<(data)
    append(data)
  end

  # @param [Array<Hash>] array
  def self.hash_arr(array)
    cls = CarCollection.new
    cls.append(array)
    cls
  end

  # @param [Array<Car>] array
  def self.hash_adv(array)
    cls = CarCollection.new
    cls.append(array)
    cls
  end
end
