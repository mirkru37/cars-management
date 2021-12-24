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
        Terminal::Table.new title: Style::Text.title('result') do |table|
          table.headings = [Style::Text.header('field'),
                            Style::Text.header('information')]
          make_rows(table, result)
        end
      end

      # @param [Terminal::Table] table
      # @param [Array<Car>] data
      def make_rows(table, data)
        data.each do |item|
          item.attributes.each do |key, value|
            value = value.strftime(Models::Car::DATE_FORMAT) if value.instance_of?(DateTime)
            table << [Style::Text.highlight(I18n.t("attributes.#{key}")), Style::Text.hint(value.to_s)]
          end
          table << :separator
        end
      end

      # @param [Models::Search] search
      def statistic(search)
        table = Terminal::Table.new title:
                                      Style::Text.title('statistic')
        Style::Table.config_search_result(table, @search_result_table_width)
        table << [Style::Text.title('total_quantity'),
                  Style::Text.hint(search.total_quantity.to_s)]
        table << [Style::Text.title('request_quantity'),
                  Style::Text.hint(search.request_quantity.to_s)]
        table.align_column(1, :right)
        puts table
      end
    end
  end
end
