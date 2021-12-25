# frozen_string_literal: true

module Style
  class Text
    class << self
      # @param [String] text
      # @param [Hash] style
      def call(text, style)
        text = text.colorize(style[:color]) if style[:color]
        return text unless style[:typeface]

        apply_typeface(text, style[:typeface])
      end

      private

      # @param [String] text
      # @param [Symbol] typeface
      def apply_typeface(text, typeface)
        case typeface
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
