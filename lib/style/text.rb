# frozen_string_literal: true

module Style
  class Text
    # @param [text] attr
    def self.attribute_(text, color: :light_magenta)
      I18n.t("attributes.#{text}").to_s.colorize(color)
    end

    # @param [String] text
    def self.title(text, color: :magenta)
      I18n.t("titles.#{text}").colorize(color).bold
    end

    # @param [String] text
    def self.header(text, color: :light_magenta)
      I18n.t("headers.#{text}").colorize(color).bold
    end

    # @param [Object] value
    def self.value(value, color: :green)
      value.to_s.colorize(color).italic
    end
  end
end

