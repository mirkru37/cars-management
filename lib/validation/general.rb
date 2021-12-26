# frozen_string_literal: true

module Validation
  class General
    class << self
      # @param [Object] value
      # @return [Integer, nil]
      def handle_int(value)
        Integer(value)
      rescue ArgumentError
        error_msg = "#{I18n.t('words.argument')} #{value}"\
                    " #{I18n.t('sentences.is_not')} #{I18n.t('words.integer')}"
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
end
