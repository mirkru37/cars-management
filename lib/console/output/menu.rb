# frozen_string_literal: true

module Output
  class Menu
    class << self
      def main(app:)
        show(App.main_menu, app: app)
      end

      # @param [Array<MenuItem>] items
      # @param [String] title
      def show(items, title: 'main', error_message: I18n.t('errors.wrong_option'), **kwargs)
        table = config_table(items, title)
        puts table
        option = Input::General.menu_option
        if option.nil? || !option.between?(1, items.length)
          puts Style::Text.error(error_message)
          show(items, title: title, error_message: error_message, **kwargs)
        else
          items[option - 1].call(**kwargs)
        end
      end

      private

      def config_table(items, title)
        rows = items.map.with_index do |item, i|
          [Style::Text.highlight((i + 1).to_s), Style::Text.hint(I18n.t("menu.#{item.title}"))]
        end
        table = Terminal::Table.new title:
                                      Style::Text.title(title)
        table.rows = rows
        Style::Table.config_general(table)
        table
      end
    end
  end
end
