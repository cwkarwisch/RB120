class Vehicle
  attr_reader :year

  def initialize(year)
    @year = year
  end

  def start_engine
    'Ready to go!'
  end
end

module Towable
  def tow
    puts "I can tow a trailer!"
  end
end

class Truck < Vehicle
  attr_reader :bed_type
  include Towable

  def initialize(year, bed_type)
    super(year)
    @bed_type = bed_type
  end

  def start_engine(speed)
    super() + " Drive #{speed}, please!"
  end

end

class Car < Vehicle

end

truck1 = Truck.new(1994, "short")
puts truck1.year
truck1.tow

car1 = Car.new(2006)
puts car1.year
