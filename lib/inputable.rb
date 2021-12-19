# frozen_string_literal: false

class Inputable
  attr_reader :name
  attr_accessor :value

  # @param [String] name
  def initialize(name)
    @name = name
    @value = ''
  end
end
