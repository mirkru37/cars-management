# database controller for YAML
require 'fileutils'

class Database
  attr_reader :path, :editable

  # @param [String] path
  def initialize(path, editable: true, create_if_not_exist: false)
    @path = path
    @editable = editable
    unless File.exist?(path)
      raise Errno::ENOENT unless create_if_not_exist

      create
    end
  end

  def load
    data = YAML.safe_load(File.open(path))
    if data.nil?
      []
    else
      data.is_a?(Array) ? data : [data]
    end
  end

  def create
    FileUtils.touch(@path)
  rescue Errno::ENOENT
    FileUtils.mkdir_p(@path.split('/')[0...-1].join('/'))
    FileUtils.touch(@path)
  end

  # @param [Object] data
  def dump(data)
    raise SecurityError, 'File is not editable' unless @editable

    File.write(@path, data.to_yaml)
  end

  private :create
end
