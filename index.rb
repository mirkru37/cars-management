# frozen_string_literal: true

require './lib/models/search_rule'
require './lib/models/search'
require './lib/input'
require './lib/i18n_config'
require './lib/output'
require './lib/database'
require './lib/models/car'
require './lib/operations/car'
require './lib/operations/search'
require './lib/filters/car'
require './lib/sorters/car'
require 'yaml'
require 'i18n'

SORT_BY = %w[price date_added].freeze
SORT_ORDER = %w[asc desc].freeze
LOCALES = %w[uk en].freeze

database = Database.new
rules = [Models::SearchRule.new('make'), Models::SearchRule.new('model'),
         Models::SearchRule.year('year_from'), Models::SearchRule.year('year_to'),
         Models::SearchRule.price('price_from'), Models::SearchRule.price('price_to')]
cars = Operations::Car.init_cars_array(database.load('db'))
searches = Operations::Search.init_searches_array(database.load('searches'))

I18nConfig.init
I18nConfig.choose_language(LOCALES)

Input.param(rules, message: I18n.t('input.request.rules'))
rules.delete_if do |rule|
  rule.value.to_s.strip.empty?
end

sort_by = Input.option(SORT_BY, default: 'date_added', message: I18n.t('input.request.sort_option'))
sort_order = Input.option(SORT_ORDER, default: 'desc', message: I18n.t('input.request.sort_order'))
puts "#{I18n.t('actions.chosen')} #{I18n.t('attributes.sort_option').downcase}: #{sort_by} " \
     "#{I18n.t('attributes.sort_order').downcase}: #{sort_order}"
result = Filters::Car.filter_by_rules(cars, rules)
result = Sorters::Car.sort(result, sort_by: sort_by, sort_order: sort_order)

search = Models::Search.new(result.length, 1, rules)
search.request_quantity = Operations::Search.count(searches, search)
Operations::Search.append(searches, search)
database.dump('searches', searches.map(&:to_hash))

Output.search_result_table_width = Operations::Car.max_attr_len(cars)
Output.search_statistic(search)
Output.search_result(result)
