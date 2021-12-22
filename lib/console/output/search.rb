# frozen_string_literal: true

require 'terminal-table'
require 'colorize'
require './lib/style/table'
require './lib/style/text'

module Output
  class Search
    MIN_LENGTH = 40
    # basically 7 is a magic number,
    # but we need it to reserve length for service symbols and layout (padding, borders, e.t.c)
    ADDITIONAL_SYMBOLS = 7

    @search_result_table_width = 80

    class << self
      # @param [Models::Search] search
      def statistic(search)
        table = Terminal::Table.new title:
                                      Style::Text.title('statistic', color: :light_green)
        Style::Table.config(table, @search_result_table_width)
        table << [Style::Text.header('total_quantity', color: :green),
                  Style::Text.value(search.total_quantity)]
        table << [Style::Text.header('request_quantity', color: :green),
                  Style::Text.value(search.request_quantity)]
        table.align_column(1, :right)
        puts table
      end

      # @param [Array<Car>] result
      def result(result)
        table = result.empty? ? Style::Table.empty_table : fill_res(result)
        Style::Table.config(table, @search_result_table_width)
        puts table
      end

      # @param [Integer] val
      def result_table_width=(val)
        val = [val, MIN_LENGTH].max
        @search_result_table_width = val + ADDITIONAL_SYMBOLS
      end

      private

      # @param [Array<Car>] result
      def fill_res(result)
        Terminal::Table.new title: Style::Text.title('result') do |table|
          table.headings = [Style::Text.header('field'), Style::Text.header('information')]
          result.each do |item|
            item.attributes.each do |key, value|
              value = value.strftime(Models::Car::DATE_FORMAT) if value.instance_of?(DateTime)
              table << [Style::Text.attribute_(key), Style::Text.value(value, color: :magenta)]
            end
            table << :separator
          end
        end
      end
    end
  end
end
