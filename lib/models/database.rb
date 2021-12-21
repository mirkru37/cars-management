# frozen_string_literal: true

require 'fileutils'
require 'yaml'

module Models
  # database controller for YAML
  class Database
    DB_PATH = 'db'

    # @param [FalseClass, TrueClass] create_if_not_exist
    def initialize(create_if_not_exist: true)
      @create_if_not_exist = create_if_not_exist
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
      path = table_path(table_name)
      data = YAML.safe_load(File.open(path))
      Array(data)
    end

    private

    # @param [String] name
    def create_table(name)
      return if table_exist?(name)

      raise Errno::ENOENT, "Table doesn't exist" unless @create_if_not_exist

      FileUtils.touch(table_path(name))
    end

    # @param [String] name
    # @return [TrueClass, FalseClass]
    def table_exist?(name)
      File.file?(table_path(name))
    end

    # @param [String] name
    # @return [String]
    def table_path(name)
      "#{DB_PATH}/#{name}.yml"
    end
  end
end
