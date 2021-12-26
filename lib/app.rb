# frozen_string_literal: true

class App
  MAIN_MENU_ATTRS = {
    search_car: :search_car,
    show_all_cars: :show_all,
    help: :help_main,
    change_language: :change_language,
    exit: :close
  }.freeze
  LOCALES = %w[uk en].freeze

  attr_reader :cars, :database, :searches

  def initialize
    I18nConfig.init
    @database = Database.new
    @cars = Operations::Car.init_cars_array(database.load('db'))
    Output::Search.result_table_width = Operations::Car.max_attr_len(@cars)
    @searches = Operations::Search.init_searches_array(database.load('searches'))
    puts Style::Text.call(I18n.t('welcome'), Style::TEXT_STYLES[:important])
  end

  class << self
    def main_menu
      MAIN_MENU_ATTRS.map { |item, option| Models::MenuItem.new(item, Menu::Options.method(option)) }
    end
  end
end
