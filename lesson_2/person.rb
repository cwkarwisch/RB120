class Person
  attr_accessor :first_name, :last_name

  def initialize(name)
    parse_full_name(name)
  end

  def name
    if @last_name == ''
      first_name
    else
    "#{@first_name} #{@last_name}"
    end
  end

  def name=(name)
    parse_full_name(name)
  end

  def to_s
    name
  end

  private

  def parse_full_name(name)
    name_arr = name.split(' ')
    self.first_name = name_arr[0]
    self.last_name = name_arr.size > 1 ? name_arr.last : ''
  end

end

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

p bob.name == rob.name
