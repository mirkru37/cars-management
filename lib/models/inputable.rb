# frozen_string_literal: false

module Models
  class Inputable
    attr_reader :name, :value

    # @param [String] name
    def initialize(name, validation_method: nil, validation_parameters: {})
      @name = name
      @value = ''
      @validation_method = validation_method
      @validation_parameters = validation_parameters
    end

    def value=(new_val)
      @value = @validation_method.nil? ? new_val : @validation_method.call(new_val, **@validation_parameters)
    end
  end
end
