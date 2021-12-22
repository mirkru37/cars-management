# frozen_string_literal: false

module Models
  class Inputable
    attr_reader :name
    attr_accessor :value

    # @param [String] name
    def initialize(name)
      @name = name
      @value = ''
    end
  end
end
