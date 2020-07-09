# How do we create an object in Ruby? Give an example of the creation of an object.

module Speak
  def speak(message)
    puts message
  end
end

class GoodDog
  include Speak
end

gabby_dog = GoodDog.new

p gabby_dog.object_id

# We create an object in Ruby using the #new method on the class that we want
# the object to be instantiated from.



# What is a module? What is its purpose? How do we use them with our classes?
# Create a module for the class you created in exercise 1 and include it properly.

# A module is a set of functionaly that can be mixed into a class by including that
# module in the class. You cannot create an object from a module. Modules provide an
# additional way of achieving polymorphism. They can be used to give the same functionality
# to many different classes.

gabby_dog.speak("roo roo roo")
