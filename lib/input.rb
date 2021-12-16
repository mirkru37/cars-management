# frozen_string_literal: true

class Input
  class << self
    # @param [Inputable] rules
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
  def option(options, default: nil, message: '')
    options = options.map(&:downcase)
    print message, ' (', options.join(' | '), ')'
    default.nil? ? puts : puts("#{I18n.t('default')}: #{default}")
    option = gets.downcase.chomp
    return option if options.include?(option)

    return default unless default.nil?

    puts I18n.t('input.wrong_option')
    options(options, default, message)
  end
end
