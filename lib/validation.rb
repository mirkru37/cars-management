# frozen_string_literal: true

require 'date'

class Validation
  class << self
    # @param [Integer] max_year
    # @param [Integer] min_year
    # @return [Integer]
    def year(value, max_year: DateTime.now.year, min_year: 1800)
      return value if value.to_s.strip.empty?

      value = handle_int(value)
      handle_range(value, max_year, min_year)
      value
    end

    # @param [Float] max_price
    # @param [Float] min_price
    # @return [Float]
    def price(value, max_price: Float::MAX, min_price: 0)
      return value if value.to_s.strip.empty?

      value = handle_float(value)
      handle_range(value, max_price, min_price)
      value
    end

    private

    # @param [Object] value
    # @return [Integer, nil]
    def handle_int(value)
      Integer(value)
    rescue ArgumentError
      error_msg = "#{I18n.t('words.argument')} #{value}"\
                  "  #{I18n.t('sentences.is_not')} #{I18n.t('words.integer')}"
      raise TypeError, error_msg
    end

    # @param [Object] value
    # @return [Float, Integer]
    def handle_float(value)
      Float(value).round(2)
    rescue ArgumentError
      error_msg = "#{I18n.t('words.argument')} #{value}"\
                  " #{I18n.t('sentences.is_not')} #{I18n.t('words.number')}"
      raise TypeError, error_msg
    end

    # @param [Float, Integer] value
    # @param [Float, Integer] max
    # @param [Float, Integer] min
    def handle_range(value, max, min)
      error_msg = "#{I18n.t('words.argument')} #{value} #{I18n.t('sentences.must_be')}"\
                  " >= #{min} #{I18n.t('words.and')} <= #{max}"
      raise TypeError, error_msg unless value >= min && value <= max
    end
  end
end
