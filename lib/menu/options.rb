# frozen_string_literal: true

module Menu
  class Options
    MAIN_QUESTIONS = %w[search show_all].freeze

    class << self
      def change_language(app:)
        locale = Input::General.option(App::LOCALES, default: 'en', message: I18n.t('input.request.language'))
        I18n.locale = locale
        Output::Search.result_table_width = Operations::Car.max_attr_len(app.cars)
        Output::Menu.main(app: app)
      end

      def close(**_)
        puts Style::Text.call(I18n.t('actions.exit'), Style::TEXT_STYLES[:important])
        exit
      end

      def search_car(app:)
        rules = Input::Search.rules
        sort_by, sort_order = Input::Search.sort
        result = filter_cars(app, rules, sort_by, sort_order)
        statistic = make_statistic(app, result, rules)
        Output::Search.search(statistic, result)
        Output::Menu.main(app: app)
      end

      def show_all(app:)
        Output::Search.result(app.cars)
        Output::Menu.main(app: app)
      end

      def help_main(app:)
        table = config_help_table(MAIN_QUESTIONS)
        puts table
        Output::Menu.main(app: app)
      end

      private

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

      # @param [App] app
      # @param [Array<SearchRule>] rules
      # @param [String] sort_by
      # @param [String] sort_order
      # @return [Array<Car>]
      def filter_cars(app, rules, sort_by, sort_order)
        result = Filters::Car.filter_by_rules(app.cars, rules)
        Sorters::Car.sort(result, sort_by: sort_by, sort_order: sort_order)
      end

      # @param [Array<Car>] result
      # @param [App] app
      def make_statistic(app, result, rules)
        statistic = Models::Search.new(result.length, 1, rules)
        statistic.request_quantity = Operations::Search.count(app.searches, statistic)
        Operations::Search.append(app.searches, statistic)
        app.database.dump('searches', app.searches.map(&:to_hash))
        statistic
      end
    end
  end
end
