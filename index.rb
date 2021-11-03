require 'yaml'

DB_DEFAULT = 'db.yml'
SEARCHING_RULES = %w[make model year_from year_to price_from price_to]
SORT_OPTIONS = %w[price date_added]
SORT_DIRS = %w[asc desc]

def is_number?(val)
  true if Float(val) rescue false
end

def is_int?(val)
  true if Integer(val) rescue false
end

def is_year?(val)
  if is_int?(val)
    return val.to_i >= 0
  end
  false
end

def is_price?(val)
  if is_number?(val)
    return val.to_f >= 0
  end
  false
end


def get_search_rules(rules)
  filled_rules = Hash.new
  puts 'Please fill search rules(If you want to skip one, just enter an empty line):'
  rules.each do |rule|
    print "\t#{rule}: "
    ans = gets.chomp
    unless ans.empty?
      if rule.include? 'year'
        if is_year?(ans)
          ans = ans.to_i
        else
          puts "\tWrong value!"
          redo
        end
      elsif rule.include? 'price'
        if is_price?(ans)
          ans = ans.to_f.truncate(2)
        else
          puts "\tWrong value!"
          redo
        end
      end
    end
    filled_rules[rule] = ans
  end
  filled_rules
end

def search(car_list, search_rules)
  search_result = []
  car_list.each do |car|
    correct = true
    car.each_pair do |key, val|
      if key == 'year' || key == 'price'
        unless search_rules[key + '_from'].nil? || search_rules[key + '_from'].to_s.empty? || val >= search_rules[key + '_from']
          correct = false
        end
        unless search_rules[key + '_to'].nil? || search_rules[key + '_to'].to_s.empty? || val <= search_rules[key + '_to']
          correct = false
        end
      else
        unless search_rules[key].nil? || search_rules[key].empty?
          if val.to_s.casecmp(search_rules[key]) != 0
            correct = false
          end
        end
      end
    end
    if correct
      search_result << car
    end
  end
  search_result
end

def print_hash_list(list)
  list.each do |item|
    item.each_pair do |key, val|
      puts key + ": " + val.to_s
    end
    puts
  end
end

def search_menu(car_list)
  search_rules = get_search_rules(SEARCHING_RULES)
  search_res = search(car_list, search_rules)
  sort_option = get_option('Input sort option (date_added|price): ')
  unless SORT_OPTIONS.include?(sort_option)
    sort_option = SORT_OPTIONS[-1]
  end
  sort_order = get_option('Input sort direction(desc|asc): ')
  unless SORT_DIRS.include?(sort_order)
    sort_order = SORT_DIRS[-1]
  end
  search_res.sort_by! do |car|
    if sort_option == 'date_added'
      d,m,y=car[sort_option].split("/")
      [y.to_i,m.to_i,d.to_i]
    else
      car[sort_option]
    end
  end
  if sort_order == 'desc'
    search_res.reverse!
  end
  puts "Results:"
  puts
  print_hash_list(search_res)
end

def get_option(message = '')
  print(message)
  gets.chomp
end

def menu(template, message = '', *args)
  template.each_pair {|key, val| puts(key + ':' + val[0])}
  option = get_option(message)
  begin
    return template[option][1].call(*args)
  rescue NoMethodError
    puts 'Wrong option'
    return menu(template, message, *args)
  end
end

$template_main = {
  '1'=>['Search',method(:search_menu)],
  '2'=>['Exit',method(:exit)]
}

def main
  car_list = YAML.load(File.open(DB_DEFAULT))
  menu($template_main, 'Input option: ', car_list)

end

main