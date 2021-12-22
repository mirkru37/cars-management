# frozen_string_literal: true

# TODO: fix requirements

require './lib/models/search_rule'
require './lib/models/search'
require './lib/console/input/general'
require './lib/i18n_config'
require './lib/console/output/search'
require './lib/console/output/menu'
require './lib/database'
require './lib/models/car'
require './lib/operations/car'
require './lib/operations/search'
require './lib/console/input/search'
require './lib/filters/car'
require './lib/sorters/car'
require './lib/menu/options'
require './lib/app'
require 'yaml'
require 'i18n'

app = App.new
Output::Menu.show(App::MAIN_MENU, app: app)
