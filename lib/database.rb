# database controller for YAML
require 'fileutils'

class Database
  attr_reader :path

  # @param [String] path
  def initialize(path, create_if_not_exist: true)
    @path = path
    @tables = {}
    @create_if_not_exist = create_if_not_exist
    create_folder
  end

  # @param [String] name
  def create_table(name)
    return if table_exist?(name)

    raise Errno::ENOENT, "Table doesn't exist" unless @create_if_not_exist

    FileUtils.touch(table_path(name))
  end

  def create_folder
    return if File.directory?(@path)

    raise Errno::ENOENT, "Database folder doesn't exist" unless @create_if_not_exist

    FileUtils.mkdir_p(@path)
  end

  # @param [String] table_name
  # @param [Object] data
  def dump(table_name, data)
    create_table(table_name)
    File.write(table_path(table_name), data.to_yaml)
  end

  # @param [String] table_name
  # @return [Array]
  def load(table_name)
    create_table(table_name)
    Array(YAML.safe_load(File.open(table_path(table_name))))
  end

  # @param [String] name
  # @return [TrueClass, FalseClass]
  def table_exist?(name)
    File.file?(table_path(name))
  end

  # @param [String] name
  # @return [String]
  def table_path(name)
    "#{@path}/#{name}.yml"
  end

  private :create_table, :create_folder
end
