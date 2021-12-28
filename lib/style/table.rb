# frozen_string_literal: true

module Style
  class Table
    # basically 7 is a magic number,
    # but we need it to reserve length for service symbols and layout (padding, borders, e.t.c)
    ADDITIONAL_SYMBOLS = 7

    class << self
      # @param [Array<String>] questions
      def config_help_table(questions)
        table = Terminal::Table.new do |t|
          t.title = Style::Text.call(I18n.t('headers.help'), Style::TEXT_STYLES[:header])
        end
        table.rows = questions.map do |question|
          [Style::Text.call(I18n.t("help.questions.#{question}"), Style::TEXT_STYLES[:highlight]),
           Style::Text.call(I18n.t("help.answers.#{question}"), Style::TEXT_STYLES[:hint])]
        end
        Style::Table.config_general(table)
        table
      end

      # @param [Terminal::Table] table
      # @param [Integer, nil] width
      def config_general(table, width = nil)
        table.style = { border_x: '=', border_i: 'x' }
        table.style = { width: width + ADDITIONAL_SYMBOLS } unless width.nil?
      end

      # @param [Terminal::Table] table
      # @param [Integer, nil] width
      def config_search_result(table, width)
        config_general(table, width)
        table.style = { border_bottom: false }
      end

      def empty_table
        Terminal::Table.new title: Text.call(I18n.t('errors.empty_table'), TEXT_STYLES[:error]) do |table|
          table << [' ']
          table << :separator
        end
      end
    end
  end
end
