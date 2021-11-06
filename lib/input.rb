
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
end
