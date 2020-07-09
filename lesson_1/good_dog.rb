class Animal

  def speak
    puts "Roo Roo!"
  end

end


class GoodDog < Animal
  attr_accessor :name, :height, :weight

  @@number_of_dogs = 0

  def initialize(name, height, weight)
    @name = name
    @height = height
    @weight = weight
    @@number_of_dogs += 1
  end

  def self.total_number_of_dogs
    @@number_of_dogs
  end

  # def name
  #   @name
  # end

  # def name=(name)
  #   @name = name
  # end

  def speak
    puts "#{name} says Roo Roo!"
  end

  def change_info(name, height, weight)
    self.name = name
    self.height = height
    self.weight = weight
  end

  def info
    "#{name} weighs #{weight} and is #{height} tall."
  end

  def self.what_am_i
    puts "I'm a GoodDog class"
  end
end


gabby = GoodDog.new("Gabby", '24 inches', '56 lbs')

gabby.speak
