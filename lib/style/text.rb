# frozen_string_literal: true

module Style
  class Text
    class << self
      # @param [String] text
      def error(text, color: :light_red)
        text.colorize(color).bold
      end

      # @param [String] text
      def header(text, color: :light_cyan)
        I18n.t("headers.#{text}").colorize(color).bold
      end

      # @param [String] text
      def highlight(text, color: :light_cyan)
        text.colorize(color)
      end

      # @param [String] text
      def hint(text, color: :cyan)
        text.colorize(color).italic
      end

      # @param [String] text
      def important(text, color: :light_green)
        text.colorize(color).bold
      end

      # @param [String] text
      def input(text, color: :light_white)
        text.colorize(color).bold
      end

      # @param [String] text
      def title(text, color: :light_cyan)
        I18n.t("titles.#{text}").colorize(color).bold
      end
    end
  end
end
