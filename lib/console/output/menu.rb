# frozen_string_literal: true

module Output
  class Menu
    class << self
      def main(**kwargs)
        show(App.main_menu, **kwargs)
      end

      # @param [Array<MenuItem>] items
      # @param [String] title
      def show(items, title: 'main', error_message: I18n.t('input.wrong_option'), **kwargs)
        table = config_table(items, title)
        puts table
        option = Input::General.menu_option
        if option.nil? || !option.between?(1, items.length)
          puts error_message.colorize(:light_red)
          show(items, title: title, error_message: error_message, **kwargs)
        else
          items[option - 1].call(**kwargs)
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
