require './lib/search'
require './lib/rules'
require './lib/input'
require './lib/output'
require './lib/database'
require 'yaml'


database = Database.new('db/db.yml', editable: false)
rules = [SearchRule.new('make'), SearchRule.new('model'),
         SearchRule.year('year_from'), SearchRule.year('year_to'),
         SearchRule.price('price_from'), SearchRule.price('price_to')]

CARS = database.load.freeze
SORT_BY = %w[price date_added].freeze
SORT_ORDER = %w[asc desc].freeze

Input.param(rules, message: 'Please input search rules(to skip one press enter)')
rules.delete_if do |rule|
  rule.value.to_s.strip.empty?
end
res = Search.filter_hash_by_rules(CARS, rules)
sort_by = Input.option(SORT_BY, default: 'date_added', message: 'Please input sort option')
sort_order = Input.option(SORT_ORDER, default: 'desc', message: 'Please input sort order')
puts "Chosen sort_by: #{sort_by} sort_order: #{sort_order}"
res.sort_by! do |car|
  if sort_by == 'date_added'
    d, m, y = car[sort_by].split('/')
    [y.to_i, m.to_i, d.to_i]
  else
    car[sort_by]
  end
end
res.reverse! if sort_order == 'desc'
puts 'Result:', ''
res.each do |item|
  Output.puts_hash(item)
  puts
end
