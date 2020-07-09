class Student
  attr_accessor :name
  attr_writer :grade

  def initialize(name)
    @name = name
  end

  def better_grade_than(other_student)
    grade > other_student.grade
  end

  protected

  attr_reader :grade

end

joe = Student.new("Joe")
bob = Student.new("Bob")

joe.grade = 95
bob.grade = 90

puts "Well done!" if joe.better_grade_than(bob)
