# frozen_string_literal: true

module Models
  class Car
    include Hashify

    ATTR_LIST = %w[id make model year odometer price description date_added].freeze
    DATE_FORMAT = '%d/%m/%y'
    # values for random generation
    ODOMETER = (10_000..200_000)
    PRICE = (1..130)
    PRICE_MULT = 1000
    DESCRIPTION_LENGTH = (4..7)
    MIN_DATE = DateTime.new(2018, 4, 16)

    attr_reader :id

    class << self
      # @param [String] id
      def random(id)
        Car.new('id' => id, **random_attrs)
      end

      private

      def random_attrs
        { 'make' => FFaker::Vehicle.make,
          'model' => FFaker::Vehicle.model,
          'year' => FFaker::Vehicle.year.to_i,
          'odometer' => FFaker::Number.rand(ODOMETER),
          'price' => FFaker::Number.rand(PRICE) * PRICE_MULT,
          'description' => FFaker::Lorem.sentence(rand(DESCRIPTION_LENGTH)),
          'date_added' => FFaker::Time.between(MIN_DATE, DateTime.now).strftime(DATE_FORMAT) }
      end
    end

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
      (ATTR_LIST.map do |attribute|
        value = instance_variable_get("@#{attribute}")
        [attribute, value]
      end).to_h
    end

    # @return [Integer]
    def max_attr_len
      attributes_ = attributes
      max_key = attributes_.keys.map { |key| I18n.t("attributes.#{key}").length }.max
      max_value = attributes_.values.map { |value| value.to_s.length }.max
      max_key + max_value
    end

    def to_hash
      hash = super
      hash['date_added'] = hash['date_added'].strftime(DATE_FORMAT)
      hash
    end

    private

    # @param [Object] self_value
    # @param [Object] value
    # @param [String] condition
    # @return [TrueClass, FalseClass]
    def compare_values(self_value, value, condition)
      case condition
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
end
