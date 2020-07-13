module Walkable
  def walk(name=@name)
    puts "#{name} #{gait} forward"
  end
end

class Noble
  attr_reader :name, :title
  include Walkable

  def initialize(name, title)
    @name = name
    @title = title
  end

  def walk
    super("#{title} #{name}")
  end

  private

  def gait
    "struts"
  end
end

class Cat
  attr_reader :name
  include Walkable

  def initialize(name)
    @name = name
  end

  private

  def gait
    "saunters"
  end
end

byron = Noble.new("Byron", "Lord")
byron.walk
# => "Lord Byron struts forward"

puts byron.name
# => "Byron"
puts byron.title
# => "Lord"

kitty = Cat.new("Kitty")
kitty.walk
# => "Kitty saunters forward"