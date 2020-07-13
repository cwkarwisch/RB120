module Walkable
  def walk
    puts "Let's go for a walk!"
  end
end


class Cat
  attr_accessor :name
  include Walkable

  @@total_cats = 0
  COLOR = 'purple'

  def self.generic_greeting
    puts "Hello! I'm a cat!"
  end

  def initialize(name)
    @name = name
    @@total_cats += 1
  end

  def personal_greeting
    puts "Hello! My name is #{name}!"
  end

  def greet
    puts "Hello! My name is #{name} and I'm a #{COLOR} cat!"
  end

  def rename(new_name)
    self.name = new_name
  end

  def identify
    self
  end

  def self.total
    puts @@total_cats
  end

  def to_s
    "I'm #{name}!"
  end

end

kitty = Cat.new('Sophie')
puts kitty
