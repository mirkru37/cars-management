require 'terminal-table'
require 'colorize'

class Output
  MIN_LENGTH = 40

  @search_result_table_width = 80

  # @param [Search] search
  def self.search_statistic(search)
    table = Terminal::Table.new title:
                                  tittle('statistic', color: :light_green)
    do_search_table_style(table)
    table << [header('total_quantity', color: :green),
              value(search.total_quantity)]
    table << [header('request_quantity', color: :green),
              value(search.request_quantity)]
    table.align_column(1, :right)
    puts table
  end

  # @param [Array<Car>] result
  def self.search_result(result)
    table = Terminal::Table.new
    if result.empty?
      table.title = tittle('empty_table', color: :light_red)
      table << [' ']
      table << :separator
    else
      table.title = tittle('result')
      table.headings = [header('field'),
                        header('information')]
      result.each do |item|
        item.attributes.each do |key, value|
          value = value.strftime(Car::DATE_FORMAT) if value.instance_of?(DateTime)
          table << [attribute_(key), value(value, color: :magenta)]
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

  # @param [String] text
  private_class_method def self.tittle(text, color: :magenta)
    I18n.t("tittles.#{text}").colorize(color).bold
  end

  # @param [String] text
  private_class_method def self.header(text, color: :light_magenta)
    I18n.t("headers.#{text}").colorize(color).bold
  end

  # @param [Object] value
  private_class_method def self.value(value, color: :green)
    value.to_s.colorize(color).italic
  end

  # @param [text] attr
  private_class_method def self.attribute_(text, color: :light_magenta)
    I18n.t("attributes.#{text}").to_s.colorize(color)
  end
end
