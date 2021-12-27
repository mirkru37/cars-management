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

      def sign_up(app:)
        user = Input::User.sign_up(app.database)
        if user.nil?
          Output::Menu.main(app: app)
        else
          app.database.append('users', user, [Models::User, BCrypt::Password])
          puts Style::Text.call(I18n.t('success.sign_up'), Style::TEXT_STYLES[:important])
          log_in(app: app, user: user)
        end
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

      def log_in(app:, user: nil)
        if user.nil?
          user = Input::User.log_in
          unless Validation::User.match?(user, app.database)
            puts Style::Text.call(I18n.t('errors.user_invalid'), Style::TEXT_STYLES[:error])
            user = nil
          end
        end
        app.user = user
        Output::Menu.main(app: app)
      end

      def log_out(app:)
        puts Style::Text.call(I18n.t('success.log_out'), Style::TEXT_STYLES[:important])
        app.user = nil
        Output::Menu.main(app: app)
      end

      private

      # @param [Array<Hash>] all_searches
      # @param [Hash] user_searches
      # @param [Search] search
      # @param [String] email
      def add_user_search(all_searches, user_searches, search, email)
        if user_searches.nil?
          all_searches << {
            'email' => email,
            'search' => [search.to_hash]
          }
        else
          user_searches['search'] << search.to_hash
        end
      end

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

      # @param [Models::Search] search
      def store_user_search(search, app)
        email = app.user.email
        all_searches = app.database.load('user_searches')
        user_searches = all_searches.find { |search_| search_['email'] == email }
        add_user_search(all_searches, user_searches, search, email)
        app.database.dump('user_searches', all_searches)
      end

      # @param [Array<Car>] result
      # @param [App] app
      def make_statistic(app, result, rules)
        statistic = Models::Search.new(result.length, 1, rules)
        statistic.request_quantity = Operations::Search.count(app.searches, statistic)
        store_user_search(statistic, app) unless app.user.nil?
        Operations::Search.append(app.searches, statistic)
        app.database.dump('searches', app.searches.map(&:to_hash))
        statistic
      end
    end
  end
end
