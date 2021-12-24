# frozen_string_literal: true

module Style
  class Text
    class << self
      # @param [String] text
      # @param [Hash] style
      def call(text, style)
        text = text.colorize(style[:color]) if style[:color]
        return text unless style[:typeface]

        case style[:typeface]
        when :bold
          text.bold
        when :italic
          text.italic
        else
          text
        end
      end
    end
  end
end
