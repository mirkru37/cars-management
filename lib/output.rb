
class Output
  # @param [Hash] hash_
  def self.puts_hash(hash_)
    hash_.each_pair do |key, value|
      puts "#{key}: #{value}"
    end
  end
end
