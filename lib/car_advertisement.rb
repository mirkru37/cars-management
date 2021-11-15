require 'date'

class CarAdv

  DATE_FORMAT = '%d/%m/%y'.freeze

  attr_reader :id, :make, :model, :year, :odometer, :price, :description, :date_added

  # @param [String] id
  # @param [String] make
  # @param [String] model
  # @param [Integer] year
  # @param [Integer] odometer
  # @param [Float, Integer] price
  # @param [String] description
  # @param [DateTime, String] date_added
  def initialize(id, make, model, year, odometer, price, description, date_added)

    @id = id
    @make = make
    @model = model
    @year = year
    @odometer = odometer
    @price = price.to_f
    @description = description
    @date_added = date_added.instance_of?(String) ? DateTime.strptime(date_added, DATE_FORMAT) : date_added
  end

  def to_s
    ["id: #{@id}", "make: #{@make}", "model: #{model}", "year: #{@year}", "odometer: #{@odometer}", "price: #{@price}",
     "description: #{@description}", "date_added: #{@date_added.strftime(DATE_FORMAT)}"].join("\n")
  end

  # @param [SearchRule] rule
  # @return [TrueClass, FalseClass]
  def fit_rule?(rule)
    name = rule.name.split('_')
    val =  instance_variable_get("@#{name[0]}")
    return false if val.nil?

    case name[-1]
    when 'to'
      val <= rule.value
    when 'from'
      val >= rule.value
    else
      val.to_s.casecmp?(rule.value.to_s)
    end
  end

end

class CarAdvCollection

  def initialize
    @adv = []
  end

  # @param [String] id
  def id?(id)
    @adv.any? { |adv| adv.id.casecmp?(id) }
  end

  # @param [CarAdv] data
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
      @adv << CarAdv.new(*data.values)
    end
  end

  # @param [Array<Hash>] data
  def append_array_hash(data)
    data.each do |hash|
      append_hash(hash)
    end
  end

  # @param [Array<CarAdv>] data
  def append_array_adv(data)
    @adv += data
  end

  # @param [Array<Hash>, Array<CarAdv>] data
  def append_array(data)
    if data.all? { |obj| obj.instance_of?(Hash) }
      append_array_hash(data)
    elsif data.all? { |obj| obj.instance_of?(CarAdv) }
      append_array_adv(data)
    else
      puts data.inspect
      raise ArgumentError, 'Invalid array members!'
    end
  end

  # @param [CarAdv, Hash, Array<Hash>, Array<CarAdv>]
  def append(data)
    if data.instance_of?(CarAdv)
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
  # @return [CarAdvCollection]
  def filter_by_rules(rules)
    res = @adv.clone
    rules.each do |rule|
      break if res.empty?

      res.filter! do |adv|
        adv.fit_rule?(rule)
      end
    end
    CarAdvCollection.hash_adv(res)
  end

  # @param [String] sort_by
  # @param [String] sort_order
  # @return [CarAdvCollection]
  def sort(sort_by: 'date_added', sort_order: 'desc')
    res = @adv.clone
    res.sort_by! do |car|
      car.instance_variable_get("@#{sort_by}")
    end
    res.reverse! if sort_order == 'desc'
    CarAdvCollection.hash_adv(res)
  end

  # @param [String] sort_by
  # @param [String] sort_order
  def sort!(sort_by: 'date_added', sort_order: 'desc')
    @adv = sort(sort_by: sort_by, sort_order: sort_order).all
  end

  def all
    @adv
  end

  # @param [CarAdv, Hash, Array<Hash>, Array<CarAdv>]
  def <<(data)
    append(data)
  end

  # @param [Array<Hash>] array
  def self.hash_arr(array)
    cls = CarAdvCollection.new
    cls.append(array)
    cls
  end

  # @param [Array<CarAdv>] array
  def self.hash_adv(array)
    cls = CarAdvCollection.new
    cls.append(array)
    cls
  end
end
