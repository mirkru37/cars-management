# frozen_string_literal: true

require 'date'
require 'ffaker'
require 'yaml'
require 'uuidtools'
require_relative 'lib/modules/hashify'
require_relative 'lib/database'
require_relative 'lib/models/car'
require_relative 'lib/operations/car'

namespace :database do
  desc 'Add one or multiple records'
  task :add_record, [:amount] do |_, args|
    amount = Integer(args.with_defaults(amount: 1)[:amount])
    db = Database.new
    amount.times do
      id = UUIDTools::UUID.timestamp_create.to_s
      car = Models::Car.random(id).to_hash
      db.append('db', car)
    end
    puts "Added #{amount} cars."
  end

  desc 'Clear database'
  task :clear do
    Dir.glob('db/*.yml') do |file|
      puts "Clearing: #{file}..."
      File.write(file, '')
    end
    puts 'Done!'
  end
end
