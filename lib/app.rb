# frozen_string_literal: true

class App
  MAIN_MENU_ATTRS = {
    search_car: :search_car,
    show_all_cars: :show_all,
    log_in: :log_in,
    sign_up: :sign_up,
    help: :help_main,
    change_language: :change_language,
    exit: :close
  }.freeze
  MAIN_MENU_LOGGED_ATTRS = {
    search_car: :search_car,
    show_all_cars: :show_all,
    log_out: :log_out,
    help: :help_main,
    change_language: :change_language,
    exit: :close
  }.freeze
  LOCALES = %w[uk en].freeze

  attr_reader :cars, :database, :searches, :user

  def initialize
    I18nConfig.init
    @database = Database.new
    @cars = Operations::Car.init_cars_array(database.load('db'))
    Output::Search.result_table_width = Operations::Car.max_attr_len(@cars)
    @searches = Operations::Search.init_searches_array(database.load('searches'))
    puts Style::Text.call(I18n.t('welcome'), Style::TEXT_STYLES[:important])
    @user = nil # initialize current user ( may be loaded from db in future )
  end

  def main_menu
    @user.nil? ? map_menu(MAIN_MENU_ATTRS) : map_menu(MAIN_MENU_LOGGED_ATTRS)
  end

  def user=(value)
    # store or delete current user from db
    @user = nil if value.nil? # never mind, it's just plug for rubocop
    @user = value
  end

  private

  def map_menu(menu_attrs)
    menu_attrs.map { |item, option| Models::MenuItem.new(item, Menu::Options.method(option)) }
  end
end
