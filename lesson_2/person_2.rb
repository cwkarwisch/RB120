class Person
  def name=(name)
    @first_name = name.split(" ")[0]
    @last_name = name.split(" ").last if name.split(" ").size > 1
  end

  def name
    "#{@first_name} #{@last_name}".strip
  end
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name
