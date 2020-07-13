#### What classes and objects are ####

- Essence precedes existence.
- A class defines what an object of a class is and what it can do.
- We define attributes of a class in the class definition.
  - Instance variables do not come into existence until they are initialized for a particular object.
  - No instance variable can be created for an object that doesn't have the corresponding attribute defined in the class definition. Essence precedes existence.
  - Even when an object is created, and no instance variable has been initialized for a particular attribute, the attribute exists in potentia in a way that is different from a local variable that has never been initialized. If we try to reference an attribute that hasn't been initialized, we will receive nil. If we try to reference a local variable that has never been initialized, we recieve an error.
- Even when a class defines an attribute, each attribute has the two contingent proerties of whether the attribute will be accessible to be viewed or changed. We control this by deciding whether or not to provide getter or setter methods for any particular attribute. This provides the necessary precondition for encapsulation.
- As few attributes and methods as possible should be public.
- Duck typing is in some ways an exceptions to essence preceding existence. With duck typing, existence in a way determines essence.


#### How class inheritance works in Ruby ####



#### How Ruby deals with multiple inheritance ####



#### Class vs instance methods and variables ####



#### Working with object oriented code ####



#### Design considerations when working with OOP ####



#### Object "truthiness" ####



#### Object equivalence ####



#### Fake operators in Ruby ####



#### Debugging OO code ####



#### Reading OO code ####



#### Working with collaborator objects ####

- A collaborator object is an object that is stored as part of the state of another object. This occurs when an onject's instance variable points to another object.

- It is helpful to think about collaborator objects when thinking about the key associative relationships between classes in our program. With collaborators, we are thinking about "has a" relationships, but not the type of "is a" relationships that are appropriate for inheritance.
  - For instance, a Library class has an important collaborative relationship with Patrons and Books, but Patrons are not a type of Library and Books are not a type of Library.
  - Objects are collaborators when one object sends a message to another object as part of fulfilling the first object's responsibilities.

#### Modules ####



#### Using CRC cards to guide design ####
