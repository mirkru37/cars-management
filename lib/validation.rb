# frozen_string_literal: true

require 'date'

class Validation
  class << self
    # @param [Integer] max_year
    # @param [Integer] min_year
    # @return [Integer]
    def year(value, max_year: DateTime.now.year, min_year: 1800)
      return value if value.to_s.strip.empty?

      int_error(value) unless int?(value)
      value = value.to_i
      range_error(value, max_year, min_year) unless value >= min_year && value <= max_year
      value
    end

    # @param [Float] max_price
    # @param [Float] min_price
    # @return [Float]
    def price(value, max_price: Float::MAX, min_price: 0)
      return value if value.to_s.strip.empty?

      number_error(value) unless number?(value)
      value = value.to_f.round(2)
      range_error(value, max_price, min_price) unless value >= min_price && value <= max_price
      value
    end

    def number?(val)
      Float(val)
    rescue ArgumentError
      false
    end

    def int?(val)
      val.to_i.to_s == val
    end

    private

    def number_error(value)
      raise TypeError, "#{I18n.t('words.argument')} #{value}"\
                       " #{I18n.t('sentences.is_not')} #{I18n.t('words.number')}"
    end

    def int_error(value)
      raise TypeError, "#{I18n.t('words.argument')} #{value}"\
                       "  #{I18n.t('sentences.is_not')} #{I18n.t('words.integer')}"
    end

    def range_error(value, max, min)
      raise TypeError, "#{I18n.t('words.argument')} #{value} #{I18n.t('sentences.must_be')}"\
                       " >= #{min} #{I18n.t('words.and')} <= #{max}"
    end
  end
end
