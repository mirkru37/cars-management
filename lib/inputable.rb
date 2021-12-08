# frozen_string_literal: true

class Inputable
  attr_reader :name
  attr_accessor :value

  # @param [String] name
  def initialize(name)
    @name = name
    @value = ''
  end
end
