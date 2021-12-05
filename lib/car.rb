require './lib/hashify'

class Car
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
