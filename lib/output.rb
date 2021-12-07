class Output
  # @param [Search] search
  def self.search_statistic(search)
    puts 'Statistic:', '',
         "\tTotal quantity: #{search.total_quantity}", '',
         "\tRequest quantity: #{search.request_quantity}", ''
  end

  # @param [Array<Car>] result
  def self.search_result(result)
    puts 'Result:', ''
    result.each do |item|
      puts item
      puts
    end
  end
end
