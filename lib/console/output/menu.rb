# frozen_string_literal: true

module Output
  class Menu
    class << self
      def main(app:)
        show(app.main_menu)
      end

      # @param [Array<MenuItem>] items
      # @param [String] title
      def show(items, title: 'main', error_message: I18n.t('errors.wrong_option'))
        table = config_table(items, title)
        puts table
        option = Input::General.menu_option
        if option.nil? || !option.between?(1, items.length)
          puts Style::Text.call(error_message, Style::TEXT_STYLES[:error])
          show(items, title: title, error_message: error_message)
        else
          items[option - 1].call
        end
      end

      private

      def config_table(items, title)
        rows = items.map.with_index do |item, i|
          [Style::Text.call((i + 1).to_s, Style::TEXT_STYLES[:highlight]),
           Style::Text.call(I18n.t("menu.#{item.title}"), Style::TEXT_STYLES[:hint])]
        end
        table = Terminal::Table.new title:
                                      Style::Text.call(I18n.t("titles.#{title}"), Style::TEXT_STYLES[:title])
        table.rows = rows
        Style::Table.config_general(table)
        table
      end
    end
  end
end
