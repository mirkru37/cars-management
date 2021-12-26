# frozen_string_literal: true

module Output
  class Search
    MIN_LENGTH = 40

    @search_result_table_width = 80

    class << self
      def search(statistic, result)
        statistic(statistic)
        result(result)
      end

      # @param [Array<Car>] result
      def result(result)
        table = result.empty? ? Style::Table.empty_table : fill_res(result)
        Style::Table.config_search_result(table, @search_result_table_width)
        puts table
      end

      # @param [Integer] val
      def result_table_width=(val)
        val = [val, MIN_LENGTH].max
        @search_result_table_width = val
      end

      private

      # @param [Array<Car>] result
      def fill_res(result)
        Terminal::Table.new title: Style::Text.call(I18n.t('titles.result'), Style::TEXT_STYLES[:title]) do |table|
          table.headings = [Style::Text.call(I18n.t('headers.field'), Style::TEXT_STYLES[:header]),
                            Style::Text.call(I18n.t('headers.information'), Style::TEXT_STYLES[:header])]
          make_rows(table, result)
        end
      end

      # @param [Terminal::Table] table
      # @param [Array<Car>] data
      def make_rows(table, data)
        data.each do |item|
          item.attributes.each do |key, value|
            value = value.strftime(Models::Car::DATE_FORMAT) if value.instance_of?(DateTime)
            table << [Style::Text.call(I18n.t("attributes.#{key}"), Style::TEXT_STYLES[:hint]),
                      Style::Text.call(value.to_s, Style::TEXT_STYLES[:hint])]
          end
          table << :separator
        end
      end

      # @param [Models::Search] search
      # @param [String] attr
      def make_attribute_row(search, attr)
        [Style::Text.call(I18n.t("attributes.#{attr}"), Style::TEXT_STYLES[:highlight]),
         Style::Text.call(search.send(attr).to_s, Style::TEXT_STYLES[:hint])]
      end

      # @param [Models::Search] search
      def statistic(search)
        table = Terminal::Table.new title:
                                      Style::Text.call(I18n.t('titles.statistic'), Style::TEXT_STYLES[:title])
        Style::Table.config_search_result(table, @search_result_table_width)
        table << make_attribute_row(search, 'total_quantity')
        table << make_attribute_row(search, 'request_quantity')
        table.align_column(1, :right)
        puts table
      end
    end
  end
end
