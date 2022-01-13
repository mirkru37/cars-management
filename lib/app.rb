# frozen_string_literal: true

class App
  MAIN_MENU_ATTRS = {
    search_car: :search_car,
    show_all_cars: :show_all,
    help: :help_main,
    change_language: :change_language,
    exit: :close
  }.freeze
  MAIN_MENU_AUTHORIZED_ATTRS = {
    log_out: :log_out,
    my_searches: :my_searches
  }.freeze
  MAIN_MENU_UNAUTHORIZED_ATTRS = {
    log_in: :log_in,
    sign_up: :sign_up
  }.freeze
  LOCALES = %w[uk en].freeze

  attr_reader :cars, :database, :searches, :user, :menu_options

  def initialize
    I18nConfig.init
    @database = Database.new
    @cars = Operations::Car.init_cars_array(database.load('db'))
    Output::Search.result_table_width = Operations::Car.max_attr_len(@cars)
    @searches = Operations::Search.init_searches_array(database.load('searches'))
    puts Style::Text.call(I18n.t('welcome'), Style::TEXT_STYLES[:important])
    @user = nil # initialize current user ( may be loaded from db in future )
    @menu_options = Menu::Options.new(self)
  end

  def main_menu
    user.nil? ? map_menu(main_menu_unauthorized) : map_menu(main_menu_authorized)
  end

  def user=(value)
    # store or delete current user from db ( save user to log in automatically )
    puts Style::Text.call((I18n.t('welcome_user') % value.email), Style::TEXT_STYLES[:important]) unless value.nil?
    @user = value
  end

  private

  def main_menu_authorized
    MAIN_MENU_ATTRS.to_a.insert(2, *MAIN_MENU_AUTHORIZED_ATTRS.to_a).to_h
  end

  def main_menu_unauthorized
    MAIN_MENU_ATTRS.to_a.insert(2, *MAIN_MENU_UNAUTHORIZED_ATTRS.to_a).to_h
  end

  # @param [Hash] menu_attrs
  def map_menu(menu_attrs)
    menu_attrs.map { |item, option| Models::MenuItem.new(item, menu_options.method(option)) }
  end
end
