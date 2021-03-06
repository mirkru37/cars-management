# frozen_string_literal: true

require 'bcrypt'
require 'colorize'
require 'date'
require 'i18n'
require 'fileutils'
require 'terminal-table'
require 'yaml'
require_relative 'validation/general'
require_relative 'modules/hashify'
require_relative 'models/car'
require_relative 'models/inputable'
require_relative 'models/menu_item'
require_relative 'models/search'
require_relative 'models/user'
require_relative 'validation/search_rule'
require_relative 'validation/user'
require_relative 'models/search_rule'
require_relative 'console/input/general'
require_relative 'console/input/search'
require_relative 'console/input/user'
require_relative 'console/output/user_searches'
require_relative 'console/output/menu'
require_relative 'console/output/search'
require_relative 'filters/car'
require_relative 'menu/options'
require_relative 'operations/car'
require_relative 'operations/search'
require_relative 'sorters/car'
require_relative 'style/table'
require_relative 'style/text'
require_relative 'style/text_styles'
require_relative 'app'
require_relative 'database'
require_relative 'i18n_config'
