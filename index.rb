require './lib/search'
require './lib/input'
require './lib/output'
require './lib/validation'
require 'yaml'

DATABASE = YAML.safe_load(File.open('data/cars.yml')).to_a
RULES_NAMES = %w[make model year_from year_to price_from price_to].freeze
RULES_VALIDATION = [nil, nil, [Validation.method(:year), {}], [Validation.method(:year), {}],
                    [Validation.method(:price), {}], [Validation.method(:price), {}]].freeze
SORT_BY = %w[price date_added].freeze
SORT_ORDER = %w[asc desc].freeze

rules = Input.param(RULES_NAMES, RULES_VALIDATION, message: 'Please input search rules(to skip one press enter)')
rules.delete_if do |key, value|
  value.to_s.strip.empty?
end
res = Search.filter_hash_by_rules(DATABASE, rules)
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


