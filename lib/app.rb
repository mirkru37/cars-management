# frozen_string_literal: true

class App
  MAIN_MENU = [Models::MenuItem.new('search_car', Menu::Options.method(:search_car)),
               Models::MenuItem.new('show_all_cars', Menu::Options.method(:show_all)),
               Models::MenuItem.new('help', Menu::Options.method(:help_main)),
               Models::MenuItem.new('change_language', Menu::Options.method(:choose_language)),
               Models::MenuItem.new('exit', Menu::Options.method(:close))].freeze
  LOCALES = %w[uk en].freeze

  attr_reader :cars
  attr_accessor :searches, :database

  def initialize
    @database = Database.new
    @cars = Operations::Car.init_cars_array(database.load('db'))
    @searches = Operations::Search.init_searches_array(database.load('searches'))
    I18nConfig.init
    Output::Search.result_table_width = Operations::Car.max_attr_len(@cars)
    puts Style::Text.welcome
  end
end
