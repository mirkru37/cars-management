# frozen_string_literal: true

class Car
  DATE_FORMAT = '%d/%m/%y'
  ATTR_LIST = %w[id make model year odometer price description date_added].freeze

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

  # @param [SearchRule] rule
  # @return [TrueClass, FalseClass]
  def fit_rule?(rule)
    name = rule.name.split('_')
    value = instance_variable_get("@#{name[0]}")
    return false if value.nil?

    compare_values(value, rule.value, name[-1])
  end

  # @return [Hash]
  def attributes
    ATTR_LIST.map do |attribute|
      value = instance_variable_get("@#{attribute}")
      [attribute, value]
    end.to_h
  end

  # @return [Integer]
  def max_attr_len
    attributes_ = attributes
    max_key = attributes_.keys.map { |key| I18n.t("attributes.#{key}").length }.max
    max_value = attributes_.values.map { |value| value.to_s.length }.max
    max_key + max_value
  end

  private

  # @param [Object] self_value
  # @param [Object] value
  # @param [String] name
  # @return [TrueClass, FalseClass]
  def compare_values(self_value, value, name)
    case name
    when 'to'
      self_value <= value
    when 'from'
      self_value >= value
    else
      self_value.casecmp?(value)
    end
  end
end
