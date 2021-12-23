# frozen_string_literal: true

module Input
  class General
    class << self
      # @return [Integer, nil]
      def menu_option
        option = Validation::General.handle_int(any(message: '--> '))
      rescue TypeError
        nil
      else
        option
      end

      # @param [Inputable] parameters
      # @param [String] message
      # @return [Inputable]
      def param(parameters, message: I18n.t('input.input_request'))
        puts message
        parameters.each do |param|
          print "\t#{I18n.t("attributes.#{param.name}").capitalize}:"
          begin
            param.value = gets.chomp
          rescue TypeError => e
            puts e
            redo
          end
        end
      end

      # @param [Array<String>] options
      # @param [String | nil] default
      # @param [String] message
      # @return [String]
      def option(options, default: nil, message: '', error_message: I18n.t('input.wrong_option'))
        options = options.map(&:downcase)
        print message, ' (', options.join(' | '), ')'
        default.nil? ? puts : puts("#{I18n.t('default')}: #{default}")
        option = gets.downcase.chomp
        return option if options.include?(option)

        return default unless default.nil?

        puts error_message
        options(options, default, message)
      end

      # @param [String] message
      def any(message: I18n.t('input.input_request'))
        print message
        gets.downcase.chomp
      end
    end
  end
end
