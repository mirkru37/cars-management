require './lib/rules'
require './lib/input'
require './lib/database'
require './lib/car'
require './lib/car_collection'
require './lib/search_collection'
require 'yaml'


database = Database.new('db/db.yml', editable: false, create_if_not_exist: true)
searches_database = Database.new('data/searches.yml', create_if_not_exist: true)
rules = [SearchRule.new('make'), SearchRule.new('model'),
         SearchRule.year('year_from'), SearchRule.year('year_to'),
         SearchRule.price('price_from'), SearchRule.price('price_to')]
cars = CarCollection.new(database.load)
searches = SearchCollection.new(searches_database.load)

SORT_BY = %w[price date_added].freeze
SORT_ORDER = %w[asc desc].freeze
Input.param(rules, message: 'Please input search rules(to skip one press enter)')
rules.delete_if do |rule|
  rule.value.to_s.strip.empty?
end

sort_by = Input.option(SORT_BY, default: 'date_added', message: 'Please input sort option')
sort_order = Input.option(SORT_ORDER, default: 'desc', message: 'Please input sort order')
puts "Chosen sort_by: #{sort_by} sort_order: #{sort_order}"
filtered = CarCollection.new(cars.filter_by_rules(rules))
res = filtered.sort(sort_by: sort_by, sort_order: sort_order)

search = Search.new(res.length, 1, rules, res)
if searches.include?(search)
  i = searches.index(search)
  searches[i].request_quantity += 1
else
  searches << search
end
searches_database.dump(searches.to_hash['searches'])
p searches.to_hash

puts 'Result:', ''
res.each do |item|
  puts item
  puts
end
