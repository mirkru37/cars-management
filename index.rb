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
# STATISTIC_TEMPLATE = { 'Total quantity': 0, 'Request quantity': 0, 'rules': {} }.freeze
SEARCHES_FILE_PATH = 'data/searches.yml'.freeze

searches = YAML.safe_load(File.open('data/searches.yml')).to_a
statistics = searches.map { |search| search['statistic'] }.to_a

def sort(data, sort_by, sort_order)
  res = data
  res.sort_by! do |car|
    if sort_by == 'date_added'
      d, m, y = car[sort_by].split('/')
      [y.to_i, m.to_i, d.to_i]
    else
      car[sort_by]
    end
  end
  res.reverse! if sort_order == 'desc'
end

rules = Input.param(RULES_NAMES, RULES_VALIDATION, message: 'Please input search rules(to skip one press enter)')
rules.delete_if do |_key, value|
  value.to_s.strip.empty?
end
res = Search.filter_hash_by_rules(DATABASE, rules)
sort_by = Input.option(SORT_BY, default: 'date_added', message: 'Please input sort option')
sort_order = Input.option(SORT_ORDER, default: 'desc', message: 'Please input sort order')
puts "Chosen sort_by: #{sort_by} sort_order: #{sort_order}"
res = sort(res, sort_by, sort_order)

local_stat = { 'Total quantity' => res.length, 'Request quantity' => 1, 'rules' => rules }
i = searches.index do |search|
  search['statistic']['rules'].eql?(rules)
end
if i.nil?
  searches << { 'statistic' => local_stat, 'result' => res }
else
  local_stat['Request quantity'] = searches[i]['statistic']['Request quantity'] + 1
  searches[i] = { 'statistic' => local_stat, 'result' => res }
end
statistics << local_stat
File.write(SEARCHES_FILE_PATH, searches.to_yaml)

puts '', 'Statistic:', ''
Output.puts_hash(local_stat)
puts '', 'Result:', ''
res.each do |item|
  Output.puts_hash(item)
  puts
end
