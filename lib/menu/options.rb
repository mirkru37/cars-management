# frozen_string_literal: true

module Menu
  class Options
    attr_reader :app

    MAIN_QUESTIONS = %w[search show_all].freeze

    def initialize(app)
      @app = app
    end

    def change_language
      locale = Input::General.option(App::LOCALES, default: 'en', message: I18n.t('input.request.language'))
      I18n.locale = locale
      Output::Search.result_table_width = Operations::Car.max_attr_len(app.cars)
      Output::Menu.main(app: app)
    end

    def close
      puts Style::Text.call(I18n.t('actions.exit'), Style::TEXT_STYLES[:important])
      exit
    end

    def my_searches
      user_searches = select_user_searches(app.user.email, app.database.load('user_searches'))
      Output::UserSearches.searches(user_searches)
      Output::Menu.main(app: app)
    end

    def search_car
      rules = Input::Search.rules
      sort_by, sort_order = Input::Search.sort
      result = filter_cars(rules, sort_by, sort_order)
      statistic = make_statistic(result, rules)
      store_user_search(statistic) unless app.user.nil?
      Output::Search.search(statistic, result)
      Output::Menu.main(app: app)
    end

    def sign_up
      user = Input::User.sign_up(app.database)
      if user.nil?
        Output::Menu.main(app: app)
      else
        app.database.append('users', user, [Models::User, BCrypt::Password])
        puts Style::Text.call(I18n.t('success.sign_up'), Style::TEXT_STYLES[:important])
        log_in(user: user)
      end
    end

    def show_all
      Output::Search.result(app.cars)
      Output::Menu.main(app: app)
    end

    def help_main
      table = Style::Table.config_help_table(MAIN_QUESTIONS)
      puts table
      Output::Menu.main(app: app)
    end

    def log_in(user: nil)
      if user.nil?
        user = Input::User.log_in
        unless user.match?(app.database)
          puts Style::Text.call(I18n.t('errors.user_invalid'), Style::TEXT_STYLES[:error])
          user = nil
        end
      end
      user.password = '' if user
      app.user = user
      Output::Menu.main(app: app)
    end

    def log_out
      puts Style::Text.call(I18n.t('success.log_out'), Style::TEXT_STYLES[:important])
      app.user = nil
      Output::Menu.main(app: app)
    end

    private

    # @param [Array<SearchRule>] rules
    # @param [String] sort_by
    # @param [String] sort_order
    # @return [Array<Car>]
    def filter_cars(rules, sort_by, sort_order)
      result = Filters::Car.filter_by_rules(app.cars, rules)
      Sorters::Car.sort(result, sort_by: sort_by, sort_order: sort_order)
    end

    # @param [Models::Search] search
    def store_user_search(search)
      all_searches, user_searches = user_search_data
      all_searches << user_searches if user_searches['searches'].empty?
      user_searches['searches'] << search.to_hash.except('request_quantity')
      app.database.dump('user_searches', all_searches)
    end

    def user_search_data
      email = app.user.email
      all_searches = app.database.load('user_searches')
      user_searches = select_user_searches(email, all_searches)
      [all_searches, user_searches]
    end

    def select_user_searches(email, all_searches)
      user_searches = all_searches.find { |search_| search_['email'] == email }
      user_searches || new_user_searches
    end

    def new_user_searches
      { 'email' => email,
        'searches' => [] }
    end

    # @param [Array<Car>] result
    def make_statistic(result, rules)
      statistic = Models::Search.new(result.length, 1, rules)
      statistic.request_quantity = Operations::Search.count(app.searches, statistic)
      Operations::Search.append(app.searches, statistic)
      app.database.dump('searches', app.searches.map(&:to_hash))
      statistic
    end
  end
end
