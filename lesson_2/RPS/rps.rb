class Player
  attr_accessor :move, :name, :score, :move_log

  def initialize
    set_name
    @score = 0
    @move_log = []
  end
end

class Human < Player
  def set_name
    system("clear") || system("cls")
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry. Must enter a name."
    end
    self.name = n
    puts
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard or spock:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice.downcase)
      puts "Sorry, that is an invalid choice."
    end
    make_move(choice.downcase)
    puts
  end

  def make_move(choice)
    case choice
    when 'rock' then self.move = Rock.new
    when 'paper' then self.move = Paper.new
    when 'scissors' then self.move = Scissors.new
    when 'lizard' then self.move = Lizard.new
    when 'spock' then self.move = Spock.new
    end
    move_log << move
  end
end

class Computer < Player
  def set_name
    @name = ['R2D2', 'Hal', 'C3PO'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class R2D2 < Computer
  def set_name
    @name = 'R2D2'
  end

  def choose
    self.move = Move.new('rock')
  end
end

class Hal < Computer
  HAL_CHOICES = ['scissors', 'scissors', 'scissors', 'scissors', 'rock']
  def set_name
    @name = 'Hal'
  end

  def choose
    self.move = Move.new(HAL_CHOICES.sample)
  end
end

class C3PO < Computer
  def set_name
    @name = 'C3PO'
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def rock?
    value == 'rock'
  end

  def paper?
    value == 'paper'
  end

  def scissors?
    value == 'scissors'
  end

  def lizard?
    value == 'lizard'
  end

  def spock?
    value == 'spock'
  end
end

class Rock < Move
  def initialize
    @value = 'rock'
  end

  def >(other_move)
    other_move.scissors? || other_move.lizard?
  end

  def <(other_move)
    other_move.paper? || other_move.spock?
  end
end

class Paper < Move
  def initialize
    @value = 'paper'
  end

  def >(other_move)
    other_move.rock? || other_move.spock?
  end

  def <(other_move)
    other_move.scissors? || other_move.lizard?
  end
end

class Scissors < Move
  def initialize
    @value = 'scissors'
  end

  def >(other_move)
    other_move.paper? || other_move.lizard?
  end

  def <(other_move)
    other_move.rock? || other_move.spock?
  end
end

class Lizard < Move
  def initialize
    @value = 'lizard'
  end

  def >(other_move)
    other_move.paper? || other_move.spock?
  end

  def <(other_move)
    other_move.scissors? || other_move.rock?
  end
end

class Spock < Move
  def initialize
    @value = 'spock'
  end

  def >(other_move)
    other_move.rock? || other_move.scissors?
  end

  def <(other_move)
    other_move.paper? || other_move.lizard?
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    select_random_computer_opponent
  end

  def select_random_computer_opponent
    choice = rand(3)
    case choice
    when 0 then self.computer = R2D2.new
    when 1 then self.computer = Hal.new
    when 2 then self.computer = C3PO.new
    end
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    puts
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock! Goodbye."
    puts
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
    puts
  end

  def play_again?
    puts "Would you like to play again?"
    answer = nil
    loop do
      answer = gets.chomp
      break if ['y', 'n'].include?(answer)
      puts "Sorry, must be y or n."
    end
    puts
    answer == 'y'
  end

  def display_moves
    puts "#{human.name} chose #{human.move.value}."
    puts "#{computer.name} chose #{computer.move.value}."
    puts
  end

  def update_score
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
      computer.score += 1
    end
  end

  def display_score
    puts "The current score is:"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
    puts
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      update_score
      display_score
      break if human.score == 5 || computer.score == 5 || !play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
