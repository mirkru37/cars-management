# frozen_string_literal: true

module Style
  class Text
    class << self
      # @param [String] text
      def answer(text, color: :cyan)
        I18n.t("help.answers.#{text}").colorize(color).italic
      end

      # @param [String] text
      def attribute_(text, color: :light_cyan)
        I18n.t("attributes.#{text}").to_s.colorize(color)
      end

      # @param [String] text
      def header(text, color: :light_green)
        I18n.t("headers.#{text}").colorize(color).bold
      end

      # @param [String] text
      def important(text, color: :light_green)
        text.colorize(color).bold
      end

      # @param [String] text
      def question(text, color: :light_cyan)
        I18n.t("help.questions.#{text}").colorize(color).bold
      end

      # @param [String] text
      def title(text, color: :light_cyan)
        I18n.t("titles.#{text}").colorize(color).bold
      end

      # @param [Object] value
      def value(value, color: :green)
        value.to_s.colorize(color).italic
      end

      def welcome
        I18n.t('welcome').colorize(:light_green).bold
      end
    end
  end
end
