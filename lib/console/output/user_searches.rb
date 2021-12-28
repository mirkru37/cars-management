# frozen_string_literal: true

module Output
  class UserSearches
    class << self
      # @param [Hash] user_searches
      def searches(user_searches)
        searches = user_searches['searches']
        table = searches.empty? ? Style::Table.empty_table : fill_searches(searches, user_searches['email'])
        Style::Table.config_search_result(table, nil)
        puts table
      end

      private

      # @param [Array<Hash>] searches
      # @param [String] email
      def fill_searches(searches, email)
        Terminal::Table.new do |table|
          table.title = Style::Text.call(I18n.t('titles.user_searches') % email, Style::TEXT_STYLES[:title])
          make_rows(searches, table)
        end
      end

      # @param [Hash] search
      # @param [Terminal::Table] table
      def fill_rules(search, table)
        search['rules'].each do |rule|
          table << [Style::Text.call(I18n.t("attributes.#{rule['name']}"), Style::TEXT_STYLES[:hint]),
                    Style::Text.call(rule['value'].to_s, Style::TEXT_STYLES[:hint])]
        end
      end

      # @param [Array<Hash>] searches
      # @param [Terminal::Table] table
      def make_rows(searches, table)
        searches.each do |search|
          table << [Style::Text.call(I18n.t('attributes.total_quantity'), Style::TEXT_STYLES[:hint]),
                    Style::Text.call(search['total_quantity'].to_s, Style::TEXT_STYLES[:hint])]
          fill_rules(search, table)
          table << :separator
        end
      end
    end
  end
end
