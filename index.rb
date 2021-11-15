require './lib/rules'
require './lib/input'
require './lib/database'
require './lib/car_advertisement'
require 'yaml'


database = Database.new('db/db.yml', editable: false)
rules = [SearchRule.new('make'), SearchRule.new('model'),
         SearchRule.year('year_from'), SearchRule.year('year_to'),
         SearchRule.price('price_from'), SearchRule.price('price_to')]
cars = CarAdvCollection.hash_arr(database.load.freeze)

SORT_BY = %w[price date_added].freeze
SORT_ORDER = %w[asc desc].freeze


Input.param(rules, message: 'Please input search rules(to skip one press enter)')
rules.delete_if do |rule|
  rule.value.to_s.strip.empty?
end
res = cars.filter_by_rules(rules)
sort_by = Input.option(SORT_BY, default: 'date_added', message: 'Please input sort option')
sort_order = Input.option(SORT_ORDER, default: 'desc', message: 'Please input sort order')
puts "Chosen sort_by: #{sort_by} sort_order: #{sort_order}"
res.sort!(sort_by: sort_by, sort_order: sort_order)
puts 'Result:', ''
res.all.each do |item|
  puts item
  puts
end
