
class Input
  # @param [Array<String>] names
  # @param [Array<Array<Method | Hash{Symbol->Integer} | nil>>] validation
  # @param [String] message
  # @return [Hash]
  def self.param(names, validation = [], message: 'Please input:')
    if !validation.empty? && validation.length != names.length
      raise IndexError, "Mismatch of 'names' and 'validation' sizes"
    end

    puts message
    res = {}
    names.each_with_index do |name, i|
      print "\t Input #{name}: "
      begin
        value = gets.chomp # valid here
        value = validation[i][0].call(value, **validation[i][1]) unless validation[i].nil?
      rescue TypeError => e
        puts e
        redo
      end
      res[name] = value
    end
    res
  end

  # @param [Array<String>] options
  # @param [String | nil] default
  # @param [String] message
  # @return [String]
  def self.option(options, default: nil, message: '')
    options = options.map(&:downcase)
    print message
    print ' (', options.join(' | '), ')'
    if default.nil?
      puts
    else
      puts " default: #{default}"
    end
    option = gets.downcase.chomp
    if options.include?(option)
      option
    elsif default.nil?
      puts 'Wrong option!!'
      options(options, default, message)
    else
      default
    end
  end
end
