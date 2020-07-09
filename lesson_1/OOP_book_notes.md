# The Object Model #

## Encapsulation ##

- Encapsulation is a way to protect data from unwanted manipulation. Encapsulation defines the boundaries in your program. By encapsulating data, data is kept in an object, where specific ways of interacting with that data are provided.

## Polymorphism ##

- Polymorphism is the ability to represent data in many different types.

## Inheritance ##

- Objects can inherit properties from another class. This class being inherited from is the superclass. We can define superclasses with broad functionality, and use subclasses to create more finely detailed objects with specific functionality.

## Module ##

- Similar to superclasses, modules provide functionality to objects that "include" the module, but you cannot create an object from a module. When a module has been included into a class, you have a 'mixin' and the functionality of that module is available to the class.

- Modules are another way to acheive polymorphism. Modules are helpful when we have many classes that we want to share the same functionality. By "including" the module in a class, it is as though we have copy-pasted all of the module's functionality directly into the class definition.

## What are Objects? ##

- Objects are instances of a class. The class is a mold, and objects are the things created from those molds. Different objects have different values, but objects of the same class were created from the same mold.

- Not everything in ruby is actually an object - methods and blocks are not. Anything that has a value is an object.

- Objects are instantiations of a class.


## Classes Define Objects ##

- Classes define what an object should be made of and what it should be able to do.


## Method Lookup ##

- When a method is called on an object, ruby follows a specific lookup path searching for the correct method. If will search through the ordered lookup path until it either finds the method or the entire path has been searched.

- This needs to be fleshed out, but we start by searching the class of the object, included modules, then superclasses.

- This is similar to the PATH we use with the terminal when we execute commands in the shell.


# Classes and Objects - Part 1 #

## States and Behaviors ##

- When defining a class, we focus on two things: states and behaviors. States are the attributes of an object of that class and behaviors are what an object of that class can do.

- Instance variables are scoped at the object level and they keep track of the state of a particular object.

- Instance methods tell us what actions an object can perform.

## Initializing a New Object ##

- We instantiate a new object by calling #new on the class, which is a class method. Calling #new on class ultimately causes #initialize, which is an instance method, to be invoked.

- #initialize is referred to as a constructor because it is called when a new object of a class is created.

## Instance Variables ##

- Instance variables track the state of each object in a class. Each object will have its own values for its instance variables.

- Instance variables are useful because they tie data to a particular object which persists. Instance variables don't disappear after the constructor (#initialize) is done executing, but persists until the object itself is destroyed. This way data remains tied to the object so that it can later be looked up or manipulated.

## Instance Methods ##

- Objects of the same class will have different states, but they will have access to the same behaviors, which are the instance methods defined in the class.

## Accessor Methods ##

- Access methods provide simple syntax for providing the common functionality of getter and setter methods for instance variables. Getter methods allow us to retrieve information about the state of an object by accessing the values assigned to the object's instance variables. Setter methods allow us to change the state of the object by changing the value of the object's instance variables.

## Calling Methods with Self ##

- Within an instance method, if you want to call a setter method, the setter method must be invoked with self. Otherwise, ruby will think we are simply declaring a local variable. For instance `name = name` wouldn't invoke the `name=` method but would create a new local variable named `name`. Using `self.name` however lets ruby know we are invoking a setter method `name=`.

- You can use self when invoking getter methods as well, but it's not required.


# Classes and Objects - Part II #

## Class Methods ##

- a method that can be called on the class itself, rather than on an instantiation of that class. Used when the method does not need to deal with the state of any particular object.

## Class Variables ##

- Variables that pertain to the class but not to particular objects of the class.

- Class variables can be accessed by instance methods (such as initialize).

## Constants ##

- Can use constants in a class for variables whose value should never change.

## The to_s Method ##

- to_s is built into every ruby class, but can be overriden by providing an instance method in our class.

- to_s is called by puts on its argument.

- inspect is called by p on its argument. We don't want to override #inspect.

- to_s ic automatically called on any object that is used in string interpolation.

## More about Self ##

- There are two placed we want to make sure to use self:
  - When calling setter methods from within the class. This is to clarify to ruby that we are not trying to create a local variable, but are changing the value of an instance or class variable.
  - When defining a Class method.

- Self refers to the calling object, which changes depending on the scope where it is used.
  - Within an instance method, self refers to the object, since it is the instantiation of the class that would be calling the instance method.
  - When outside of a definition of an instance method, self refers to the class.


# Inheritance #

## Class Inheritance ##

- Subclasses inherit functionality from superclasses.

- When a subclass inherits from a superclass, all methods of the superclass are made available to instances of the subclass.

## super ##

- super is a built-in method that will look into a class's superclasses for a method of the same name as the method from which super is invoked.

- if super is invoked without any arguments, super will pass to the superclass method all of the arguments passed into the method from which super is invoked.

- super can be invoked with specific arguments, including arguments passed into the method from which super is invoked, and when invoked with specific arguments, super will pass only those arguments to the superclass method of the same name

- super can be used to access a method of a superclass but then extend its functionality in a specific way

- super is commonly used to extend initialize

## Mixing in Modules ##

- Modules allow us to group together methods that don't fit neatly into a purely hierarchical inheritance structure.

## Inheritance vs. Modules ##

- Class inheritance is the traditional way of thinking about inheritance, but the  other approach, known as interface inheritance, is when modules are used to provide functionality.

- There are a number of considerations for choosing between class vs interface inheritance:
  - You can only inherit from one superclass, but you can mix in as many modules as you'd like.
  - If an object "is an" example of a type, class inheritance is likely the appropriate choice, but if an object "has an" ability to do something, interface inheritance is likely the better choice.
  - You cannot create an object from a module. Modules are only used for namespacing and grouping together related behaviors (i.e., methods).

## Method Lookup Path ##

- The method lookup path follows this pattern (items higher on the list are checked first):
  - class of the object
  - modules included by the class of the object (ruby checks the last included module first)
  - superclass
  - any modules included by the superclass
  - Object class
  - Kernel module
  - BasicObject class

## More Modules ##

- There are two additional uses for modules: as namespaces and as containers.
  - Namespaces are used to group together related classes. The classes are defined within the module.
  - Containers house related methods.
  - **** Need to flesh these out. I don't really follow. ****

## Private, Protected, and Public ##

- Public methods are available both inside and outside of the class.
- Private methods are only available within the class definition itself. A private method can be called by another method within the class, but the private method could not be invoked directly on an object of that class. Before ruby 2.7, even within a class, a private method could not be invoked directly on self within the class definition.
- Protected methods fit in between public and private methods, but are not used much in practice. Protected methods are available inside the class just like public methods, but outside the class, act like private methods.

## Accidental Method Overriding ##

- Methods defined in a subclass will override methods defined in a superclass.

- We have to be careful, inparticular, not to accidentally override methods defined in the Object class, which are available to all classes in ruby.
