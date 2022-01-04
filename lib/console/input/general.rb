# frozen_string_literal: true

module Input
  class General
    class << self
      # @return [Integer, nil]
      def menu_option
        option = Validation::General.handle_int(request_text(message: '--> '))
      rescue TypeError
        nil
      else
        option
      end

      # @param [Array<Inputable>] parameters
      # @param [String] message
      # @return [Inputable]
      def param(parameters, message: nil)
        puts Style::Text.call(message, Style::TEXT_STYLES[:input]) if message
        parameters.each do |param|
          print_attr_name(param)
          begin
            param.value = gets.chomp
          rescue StandardError => e
            puts Style::Text.call(e.message, Style::TEXT_STYLES[:error])
            redo
          end
        end
      end

      # @param [Array<String>] options
      # @param [String | nil] default
      # @param [String] message
      # @return [String, nil]
      def option(options, default: nil, message: '', error_message: I18n.t('errors.wrong_option'))
        options = options.map(&:downcase)
        print_options(options, default, message)
        option = gets.downcase.chomp
        return option if options.include?(option)

        return default unless default.nil?

        puts Style::Text.call(error_message, Style::TEXT_STYLES[:error])
        option(options, default: default, message: message, error_message: error_message)
      end

      private

      # @param [String] message
      def request_text(message: I18n.t('input.input_request'))
        print Style::Text.call(message, Style::TEXT_STYLES[:input])
        gets.downcase.chomp
      end

      # @param [Inputable] attr
      def print_attr_name(attr)
        print Style::Text.call("\t#{I18n.t("attributes.#{attr.name}").capitalize}:", Style::TEXT_STYLES[:input])
      end

      # @param [Array<String>] options
      # @param [String | nil] default
      # @param [String] message
      def print_options(options, default, message)
        print Style::Text.call("#{message} ( #{options.join(' | ')} ) ", Style::TEXT_STYLES[:input])
        default.nil? ? puts : puts(Style::Text.call("#{I18n.t('default')}: #{default}", Style::TEXT_STYLES[:input]))
      end
    end
  end
end
