require './lib/search_rule'
require './lib/search_counter'
require './lib/input'
require './lib/output'
require './lib/database'
require './lib/car'
require './lib/car_collection'
require './lib/search_collection'
require 'yaml'
require 'i18n'

SORT_BY = %w[price date_added].freeze
SORT_ORDER = %w[asc desc].freeze
LOCALES = %w[ua en].freeze

database = Database.new
rules = [SearchRule.new('make'), SearchRule.new('model'),
         SearchRule.year('year_from'), SearchRule.year('year_to'),
         SearchRule.price('price_from'), SearchRule.price('price_to')]
cars = CarCollection.new(database.load('db'))
searches = SearchCollection.new(database.load('searches'))

I18n.load_path << Dir["#{File.expand_path('config/locales')}/*.yml"]
locale = Input.option(LOCALES, default: 'en', message: I18n.t('input.request.language'))
I18n.locale = locale

Input.param(rules, message: I18n.t('input.request.rules'))
rules.delete_if do |rule|
  rule.value.to_s.strip.empty?
end

sort_by = Input.option(SORT_BY, default: 'date_added', message: I18n.t('input.request.sort_option'))
sort_order = Input.option(SORT_ORDER, default: 'desc', message: I18n.t('input.request.sort_order'))
puts "#{I18n.t('actions.chosen')} #{I18n.t('attributes.sort_option').downcase}: #{sort_by} " \
     "#{I18n.t('attributes.sort_order').downcase}: #{sort_order}"
filtered = CarCollection.new(cars.filter_by_rules(rules))
res = filtered.sort(sort_by: sort_by, sort_order: sort_order)

search = Search.new(res.length, 1, rules)
search.request_quantity = SearchCounter.call(searches, search)
searches.append(search)

database.dump('searches', searches.to_hash['searches'])

Output.search_result_table_width = cars.max_attr_len
Output.search_statistic(search)
Output.search_result(res)
