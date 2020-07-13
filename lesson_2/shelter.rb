class Pet
  attr_reader :type, :name

  def initialize(animal_type, name)
    @type = animal_type
    @name = name
  end
end

class Owner
  attr_reader :name
  attr_accessor :number_of_pets

  def initialize(name)
    @name = name
    @number_of_pets = 0
  end

  def adopt
    self.number_of_pets += 1
  end

end

class Shelter

  def initialize
    @adoptions = {}
  end

  def adopt(owner, pet)
    owner.adopt
    if @adoptions.has_key?(owner.name)
      @adoptions[owner.name] << pet
    else
      @adoptions[owner.name] = [pet]
    end
  end

  def print_adoptions
    @adoptions.keys.each do |owner_name|
      puts "#{owner_name} has adopted the following pets:"
      @adoptions[owner_name].each do |pet|
        puts "a #{pet.type} named #{pet.name}"
      end
      puts ""
    end
    puts ""
  end

  private

  attr_accessor :adoptions

end



butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."

# P Hanson has adopted the following pets:
# a cat named Butterscotch
# a cat named Pudding
# a bearded dragon named Darwin

# B Holmes has adopted the following pets:
# a dog named Molly
# a parakeet named Sweetie Pie
# a dog named Kennedy
# a fish named Chester

# P Hanson has 3 adopted pets.
# B Holmes has 4 adopted pets.
