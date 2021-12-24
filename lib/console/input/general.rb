# frozen_string_literal: true

module Input
  class General
    class << self
      # @return [Integer, nil]
      def menu_option
        option = Validation::General.handle_int(text(message: '--> '))
      rescue TypeError
        nil
      else
        option
      end

      # @param [Inputable] parameters
      # @param [String] message
      # @return [Inputable]
      def param(parameters, message: I18n.t('input.input_request'))
        puts Style::Text.input(message)
        parameters.each do |param|
          print Style::Text.input("\t#{I18n.t("attributes.#{param.name}").capitalize}:")
          begin
            param.value = gets.chomp
          rescue TypeError => e
            puts Style::Text.error(e.message)
            redo
          end
        end
      end

      # @param [Array<String>] options
      # @param [String | nil] default
      # @param [String] message
      # @return [String]
      def option(options, default: nil, message: '', error_message: I18n.t('errors.wrong_option'))
        options = options.map(&:downcase)
        print_options(options, default, message)
        option = gets.downcase.chomp
        return option if options.include?(option)

        return default unless default.nil?

        puts Style::Text.error(error_message)
        options(options, default, message)
      end

      private

      # @param [String] message
      def text(message: I18n.t('input.input_request'))
        print Style::Text.input(message)
        gets.downcase.chomp
      end

      # @param [Array<String>] options
      # @param [String | nil] default
      # @param [String] message
      def print_options(options, default, message)
        print Style::Text.input("#{message} ( #{options.join(' | ')} ) ")
        default.nil? ? puts : puts(Style::Text.input("#{I18n.t('default')}: #{default}"))
      end
    end
  end
end
