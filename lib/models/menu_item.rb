# frozen_string_literal: true

module Models
  class MenuItem
    attr_reader :title

    # @param [String] title
    # @param [Method] method
    def initialize(title, method)
      @title = title
      @method = method
    end

    def call(**kwargs)
      @method.call(**kwargs)
    end
  end
end
