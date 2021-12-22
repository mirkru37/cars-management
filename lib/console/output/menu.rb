# frozen_string_literal: true

require './lib/models/menu_item'

module Output
  class Menu
    class << self
      # @param [Array<MenuItem>] items
      # @param [String] title
      def show(items, title: 'main', error_message: I18n.t('input.wrong_option'), **kwargs)
        table = config_table(items, title)
        puts table
        option = Input::General.any(message: '--> ').to_i
        if option.between?(1, items.length)
          items[option - 1].call(**kwargs)
        else
          puts error_message
          show(items, title: title, error_message: error_message, **kwargs)
        end
      end

      private

      def config_table(items, title)
        rows = items.map.with_index do |item, i|
          [(i + 1).to_s.colorize(:light_blue).bold, I18n.t("menu.#{item.title}").colorize(:blue)]
        end
        table = Terminal::Table.new title:
                                      Style::Text.title(title, color: :light_blue)
        table.rows = rows
        Style::Table.config_general(table)
        table
      end
    end
  end
end
