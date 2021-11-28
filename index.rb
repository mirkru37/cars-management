require './lib/search_rule'
require './lib/input'
require './lib/output'
require './lib/database'
require './lib/car'
require './lib/car_collection'
require './lib/search_collection'
require 'yaml'
require 'i18n'

DB_PATH = 'db/db.yml'.freeze
SEARCHES_PATH = '/db.yml'.freeze

I18n.load_path << Dir["#{File.expand_path('config/locales')}/*.yml"]
I18n.locale = :ua

database = Database.new('db/db.yml', editable: false, create_if_not_exist: true)
searches_database = Database.new('data/searches.yml', create_if_not_exist: true)
rules = [SearchRule.new('make'), SearchRule.new('model'),
         SearchRule.year('year_from'), SearchRule.year('year_to'),
         SearchRule.price('price_from'), SearchRule.price('price_to')]
cars = CarCollection.new(database.load)
searches = SearchCollection.new(searches_database.load)

SORT_BY = %w[price date_added].freeze
SORT_ORDER = %w[asc desc].freeze
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
searches << search

searches_database.dump(searches.to_hash['searches'])

Output.search_result_table_width = cars.max_attr_len
Output.search_statistic(search)
Output.search_result(res)
