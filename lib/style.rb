# frozen_string_literal: true

module Style
  class Table
    # @param [Terminal::Table] table
    def self.config_search(table, table_width)
      table.style = { width: table_width, border_bottom: false, border_x: '=', border_i: 'x' }
    end

    def self.empty_table
      Terminal::Table.new title: Text.title('empty_table', color: :light_red) do |table|
        table << [' ']
        table << :separator
      end
    end
  end

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
