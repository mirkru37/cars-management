require 'date'

class Validation
  def self.year(value, max_year: DateTime.now.year, min_year: 1800)
    raise TypeError, "Argument #{value} is not a int" unless int?(value)

    value = value.to_i
    unless value >= min_year && value <= max_year
      raise TypeError, "Argument #{value} must be >= #{min_year} and <= #{max_year}"
    end

    value
  end

  def self.price(value, max_price: Float::MAX, min_price: 0)
    raise TypeError, "Argument #{value} is not a number" unless number?(value)

    value = value.to_f.round(2)
    unless value >= min_price && value <= max_price
      raise TypeError, "Argument #{value} must be >= #{min_price} and <= #{max_price}"
    end

    value
  end

  def self.number?(val)
    Float(val)
  rescue TypeError
    false

  end

  def self.int?(val)
    val.to_i.to_s == val
  end
end
