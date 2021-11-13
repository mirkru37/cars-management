# database controller for YAML

class Database
  attr_reader :path, :editable

  # @param [String] path
  def initialize(path, editable: true)
    YAML.safe_load(File.open(path))
    @path = path
    @editable = editable
  end

  def load
    YAML.safe_load(File.open(path)).to_a
  end

  # @param [Object] data
  def dump(data)
    raise SecurityError, 'File is not editable' unless @editable

    File.write(@path, data.to_yaml)
  end
end
