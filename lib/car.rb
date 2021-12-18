# frozen_string_literal: true

class Car
  DATE_FORMAT = '%d/%m/%y'
  ATTR_LIST = %w[id make model year odometer price description date_added].freeze

  def initialize(**kwargs)
    ATTR_LIST.each do |attr|
      kwargs[attr] = format_attribute(kwargs[attr], attr)
      instance_variable_set("@#{attr}", kwargs[attr])
    end
  end

  # @param [SearchRule] rule
  # @return [TrueClass, FalseClass]
  def fit_rule?(rule)
    name, condition = rule.name.split('_')
    value = instance_variable_get("@#{name}")
    return false if value.nil?

    compare_values(value, rule.value, condition)
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

  # @param [Object] value
  # @param [String] attr_name
  def format_attribute(value, attr_name)
    case attr_name
    when 'date_added'
      value.instance_of?(String) ? DateTime.strptime(value, DATE_FORMAT) : value
    else
      value
    end
  end
end
