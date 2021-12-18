# frozen_string_literal: true

require './lib/search_rule'
require './lib/search'
require './lib/search_counter'
require './lib/input'
require './lib/i18n_config'
require './lib/output'
require './lib/database'
require './lib/car'
require './lib/controller/cars'
require './lib/controller/searches'
require './lib/filter/cars'
require './lib/sorter/cars'
require 'yaml'
require 'i18n'

SORT_BY = %w[price date_added].freeze
SORT_ORDER = %w[asc desc].freeze
LOCALES = %w[uk en].freeze

database = Database.new
rules = [SearchRule.new('make'), SearchRule.new('model'),
         SearchRule.year('year_from'), SearchRule.year('year_to'),
         SearchRule.price('price_from'), SearchRule.price('price_to')]
cars = Controller::Cars.init(database.load('db'))
searches = Controller::Searches.init(database.load('searches'))

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
filtered = Filter::Cars.filter_by_rules(cars, rules)
result = Sorter::Cars.sort(filtered, sort_by: sort_by, sort_order: sort_order)

search = Search.new(result.length, 1, rules)
search.request_quantity = SearchCounter.call(searches, search)
if search.request_quantity == 1
  searches << search
else
  Controller::Searches.replace(searches, search)
end
database.dump('searches', searches.map(&:to_hash))

Output.search_result_table_width = Controller::Cars.max_attr_len(cars)
Output.search_statistic(search)
Output.search_result(result)
