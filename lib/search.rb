
class Search
  # @param [Array<Hash>] data
  # @param [String] key
  # @param [Object] value
  # @return [Array<Hash>]
  def self.filter_hash_by_key(data, key, value)
    key = key.to_s
    case key.split('_')[-1]
    when 'to'
      key = key.split('_')[...-1].join
      data.select do |item|
        item.key?(key) && item[key] <= value
      end
    when 'from'
      key = key.split('_')[...-1].join
      data.select do |item|
        item.key?(key) && item[key] >= value
      end
    else
      data.select do |item|
        item.key?(key) && item[key].to_s.casecmp?(value.to_s)
      end
    end
  end

  # @param [Array<Hash>] data
  # @param [Hash] rules
  # @return [Array<Hash>]
  def self.filter_hash_by_rules(data, rules)
    res = data
    rules.each_pair do |key, value|
      break if res.empty?

      res = filter_hash_by_key(res, key, value)
    end
    res
  end
end
