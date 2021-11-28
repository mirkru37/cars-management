require 'terminal-table'

class Output
  @search_result_table_width = 80

  attr_reader :search_result_table_width

  # @param [Search] search
  def self.search_statistic(search)
    table = Terminal::Table.new title: 'Statistic'
    set_search_table_style(table)
    table << ['Total quantity', search.total_quantity]
    table << ['Request quantity', search.request_quantity]
    table.align_column(1, :right)
    puts table
  end

  # @param [Terminal::Table] table
  def self.set_search_table_style(table)
    table.style = { width: @search_result_table_width, border_bottom: false, border_x: '=', border_i: 'x'}
  end

  # @param [Array<Car>] result
  def self.search_result(result)
    table = Terminal::Table.new
    table.title = 'Result'
    table.headings = %w[Field Information]
    set_search_table_style(table)
    result.each do |item|
      item.attributes.each do |key, value|
        table << [key, value]
      end
      table << :separator
    end
    puts table
  end

  # @param [Integer] val
  def self.search_result_table_width= (val)
    raise ArgumentError, 'Value for width must be positive' unless val.positive?

    # basically 7 is a magic number,
    # but we need it to reserve length for service symbols and layout (padding, borders, e.t.c)
    @search_result_table_width = val + 7
  end
end
