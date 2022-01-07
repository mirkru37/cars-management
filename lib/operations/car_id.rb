# frozen_string_literal: true

module Operations
  class CarId
    ID_SEP_LENGTH = [8, 4, 4, 4, 12].freeze
    ID_LENGTH = ID_SEP_LENGTH.sum

    class << self
      # @param [Array<Models::Car>] cars
      def max(cars)
        max = '0' * ID_LENGTH
        cars.each do |car|
          id = car.id.delete('-')
          max = id if id.hex > max.hex
        end
        format_hex(max)
      end

      # @param [String] id
      def next(id)
        next_id = id.delete('-').hex + 1
        next_id = next_id.to_s(16)
        next_id = ('0' * (ID_LENGTH - next_id.length)) + next_id
        format_hex(next_id)
      end

      private

      # @param [String] hex
      def format_hex(hex)
        letters = hex.chars
        chunks = ID_SEP_LENGTH.map { |n| letters.shift(n) }
        chunks.map(&:join).join('-')
      end
    end
  end
end
