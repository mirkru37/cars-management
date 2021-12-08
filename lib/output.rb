require 'terminal-table'
require 'colorize'

class Output
  MIN_LENGTH = 40

  @search_result_table_width = 80

  # @param [Search] search
  def self.search_statistic(search)
    table = Terminal::Table.new title:
                                  I18n.t('tittles.statistic').colorize(color: :light_green).bold
    do_search_table_style(table)
    table << [I18n.t('attributes.total_quantity').colorize(:green),
              search.total_quantity.to_s.colorize(:green).italic]
    table << [I18n.t('attributes.request_quantity').colorize(:green),
              search.request_quantity.to_s.colorize(:green).italic]
    table.align_column(1, :right)
    puts table
  end

  # @param [Array<Car>] result
  def self.search_result(result)
    table = Terminal::Table.new
    if result.empty?
      table.title = 'Table is empty'.colorize(:light_red).bold
      table << [' ']
      table << :separator
    else
      table.title = I18n.t('tittles.result').colorize(:light_magenta).bold
      table.headings = [I18n.t('headers.field').colorize(:light_magenta).bold,
                        I18n.t('headers.information').colorize(:light_magenta).bold]
      result.each do |item|
        item.attributes.each do |key, value|
          value = value.strftime(Car::DATE_FORMAT) if value.instance_of?(DateTime)
          table << [I18n.t("attributes.#{key}").to_s.colorize(:light_magenta), value.to_s.colorize(:magenta).italic]
        end
        table << :separator
      end
    end
    do_search_table_style(table)
    puts table
  end

  # @param [Integer] val
  def self.search_result_table_width=(val)
    val = MIN_LENGTH if !val.positive? || val < MIN_LENGTH
    # basically 7 is a magic number,
    # but we need it to reserve length for service symbols and layout (padding, borders, e.t.c)
    @search_result_table_width = val + 7
  end

  # @param [Terminal::Table] table
  private_class_method def self.do_search_table_style(table)
    table.style = { width: @search_result_table_width, border_bottom: false, border_x: '=', border_i: 'x' }
  end
end
