# frozen_string_literal: true

require 'date'
require 'ffaker'
require 'yaml'
require 'securerandom'
require_relative 'lib/modules/hashify'
require_relative 'lib/database'
require_relative 'lib/models/car'
require_relative 'lib/operations/car_id'
require_relative 'lib/operations/car'

namespace :database do
  desc 'Add one or multiple records'
  task :add_record, [:amount] do |_, args|
    amount = args.amount.nil? ? 1 : Integer(args.amount)
    db = Database.new
    cars = Operations::Car.init_cars_array(db.load('db'))
    id = Operations::CarId.max(cars)
    amount.times do
      id = Operations::CarId.next(id)
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
