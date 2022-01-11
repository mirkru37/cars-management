# frozen_string_literal: true

module Output
  class UserSearches
    class << self
      # @param [Hash] user_searches
      def searches(user_searches)
        searches = user_searches['searches']
        table = searches.empty? ? Style::Table.empty_table : fill_searches(searches)
        Style::Table.config_search_result(table, nil)
        puts table
      end

      private

      # @param [Array<Hash>] searches
      def fill_searches(searches)
        Terminal::Table.new do |table|
          table.title = Style::Text.call(I18n.t('titles.user_searches'), Style::TEXT_STYLES[:title])
          fill_rows(searches, table)
        end
      end

      # @param [Array<Hash>] searches
      # @param [Terminal::Table] table
      def fill_rows(searches, table)
        searches.each do |search|
          table << [Style::Text.call(I18n.t('attributes.total_quantity'), Style::TEXT_STYLES[:hint]),
                    Style::Text.call(search['total_quantity'].to_s, Style::TEXT_STYLES[:hint])]
          fill_rules(search['rules'], table)
          table << :separator
        end
      end

      # @param [Array<Hash>] rules
      # @param [Terminal::Table] table
      def fill_rules(rules, table)
        rules.each do |rule|
          table << [Style::Text.call(I18n.t("attributes.#{rule['name']}"), Style::TEXT_STYLES[:hint]),
                    Style::Text.call(rule['value'].to_s, Style::TEXT_STYLES[:hint])]
        end
      end
    end
  end
end
