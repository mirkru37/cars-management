
class Input
  # @param [Inputable] rules
  # @param [String] message
  # @return [Inputable]
  def self.param(parameters, message: 'Please input:')
    puts message
    parameters.each do |param|
      print "\t Input #{param.name}: "
      begin
        param.value = gets.chomp
      rescue TypeError => e
        puts e
        redo
      end
    end
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
