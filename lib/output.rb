require 'terminal-table'
require 'colorize'

class Output
  @search_result_table_width = 80

  attr_reader :search_result_table_width

  # @param [Search] search
  def self.search_statistic(search)
    table = Terminal::Table.new title:
                                  I18n.t('tittles.statistic').colorize(color: :light_green).bold
    set_search_table_style(table)
    table << [I18n.t('attributes.total_quantity').colorize(:green),
              search.total_quantity.to_s.colorize(:green).italic]
    table << [I18n.t('attributes.request_quantity').colorize(:green),
              search.request_quantity.to_s.colorize(:green).italic]
    table.align_column(1, :right)
    puts table
  end

  # @param [Terminal::Table] table
  def self.set_search_table_style(table)
    table.style = { width: @search_result_table_width, border_bottom: false, border_x: '=', border_i: 'x' }
  end

  # @param [Array<Car>] result
  def self.search_result(result)
    table = Terminal::Table.new
    table.title = I18n.t('tittles.result').colorize(:light_magenta).bold
    table.headings = [I18n.t('headers.field').colorize(:light_magenta).bold,
                      I18n.t('headers.information').colorize(:light_magenta).bold]
    set_search_table_style(table)
    result.each do |item|
      item.attributes.each do |key, value|
        table << [I18n.t("attributes.#{key}").to_s.colorize(:light_magenta), value.to_s.colorize(:magenta).italic]
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
