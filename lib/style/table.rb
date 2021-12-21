# frozen_string_literal: true

module Style
  class Table
    class << self
      # @param [Terminal::Table] table
      def config(table, table_width)
        table.style = { width: table_width, border_bottom: false, border_x: '=', border_i: 'x' }
      end

      def empty_table
        Terminal::Table.new title: Text.title('empty_table', color: :light_red) do |table|
          table << [' ']
          table << :separator
        end
      end
    end
  end
end
