# frozen_string_literal: true

module Menu
  class Options
    MAIN_QUESTIONS = %w[search show_all].freeze

    class << self
      def change_language(**kwargs)
        locale = Input::General.option(App::LOCALES, default: 'en', message: I18n.t('input.request.language'))
        I18n.locale = locale
        Output::Search.result_table_width = Operations::Car.max_attr_len(kwargs[:app].cars)
        Output::Menu.main(**kwargs)
      end

      def close(**_)
        puts Style::Text.important(I18n.t('actions.exit'))
        exit
      end

      def search_car(kwargs = {})
        rules = Input::Search.rules
        sort_by, sort_order = Input::Search.sort
        result = filter_cars(kwargs[:app], rules, sort_by, sort_order)
        statistic = make_statistic(result, rules, kwargs[:app])
        Output::Search.search(statistic, result)
        Output::Menu.main(**kwargs)
      end

      def show_all(**kwargs)
        Output::Search.result(kwargs[:app].cars)
        Output::Menu.main(**kwargs)
      end

      def help_main(**kwargs)
        table = config_help_table(MAIN_QUESTIONS)
        puts table
        Output::Menu.main(**kwargs)
      end

      private

      # @param [Array<String>] questions
      def config_help_table(questions)
        table = Terminal::Table.new do |t|
          t.title = Style::Text.header('help', color: :light_cyan)
        end
        table.rows = questions.map do |question|
          [Style::Text.question(question), Style::Text.answer(question)]
        end
        Style::Table.config_general(table)
        table
      end

      def filter_cars(app, rules, sort_by, sort_order)
        result = Filters::Car.filter_by_rules(app.cars, rules)
        Sorters::Car.sort(result, sort_by: sort_by, sort_order: sort_order)
      end

      # @param [Array<Car>] result
      # @param [App] app
      def make_statistic(result, rules, app)
        statistic = Models::Search.new(result.length, 1, rules)
        statistic.request_quantity = Operations::Search.count(app.searches, statistic)
        Operations::Search.append(app.searches, statistic)
        app.database.dump('searches', app.searches.map(&:to_hash))
        statistic
      end
    end
  end
end
