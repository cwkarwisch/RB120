module Campable

  def camp
    puts "We put a camper over the bed and are ready to camp!"
  end

end

class Vehicle
  attr_accessor :color, :current_speed
  attr_reader :year, :model

  @@total_vehicles = 0

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
    @@total_vehicles += 1
  end

  def self.print_total_number_of_vehicles
    puts "There are #{@@total_vehicles} vehicles in total."
  end

  def to_s
    "The car is a #{year} #{color} #{model}."
  end

  def speed_up(increase)
    self.current_speed = current_speed + increase
  end

  def brake(decrease)
    self.current_speed = current_speed - decrease
  end

  def shut_off
    self.current_speed = 0
  end

  def self.calculate_gas_mileage(gallons, miles)
    puts "The gas mileage of the car is #{miles / gallons.to_f} miles per gallon."
  end

  def spray_paint(color)
    self.color = color
  end

  def age
    puts "This vehicle is #{calculate_age} years old."
  end

  private

  def calculate_age
    Time.now.year - year.to_i
  end

end

class MyCar < Vehicle

  def initialize(year, color, model)
    super
  end

end

class MyTruck < Vehicle

  def initialize(year, color, model)
    super
  end

  include Campable

end

first_car = MyCar.new("1988", "blue", "Bonneville")
truck = MyTruck.new("2001", "brown", "Ranger")

first_car.age
