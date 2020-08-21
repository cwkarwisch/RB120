class GuessingGame

  def initialize
    @guesses = 7
    @number = rand(1..100)
    @guess = nil
  end

  def play
    system 'clear'
    while guesses > 0
      display_guesses_remaining
      ask_for_number
      evaluate_guess
      break if guess == number
      @guesses -= 1
    end
    display_result
  end

  private

  attr_reader :guesses, :guess, :number

  def prompt(message)
    puts ">>> #{message}"
  end

  def display_guesses_remaining
    prompt "You have #{guesses} guesses remaining."
  end

  def ask_for_number
    print ">>> Enter a number between 1 and 100: "
    loop do
      @guess = gets.chomp.to_i
      break if (1..100).include?(guess)
      print ">>> Invalid Guess. Enter a number between 1 and 100: "
    end
  end

  def evaluate_guess
    if guess < number
      prompt "Your guess is too low."
    elsif guess > number
      prompt "Your guess is too high."
    else
      prompt "That's the number!"
    end
    puts ""
  end

  def display_result
    if guess == number
      prompt "You won!"
    else
      prompt "You have no more guesses. You lost!"
    end
    puts ""
  end

end


game = GuessingGame.new
game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 104
# Invalid guess. Enter a number between 1 and 100: 50
# Your guess is too low.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 75
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 85
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 0
# Invalid guess. Enter a number between 1 and 100: 80

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 81
# That's the number!

# You won!

# game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 50
# Your guess is too high.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 25
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 37
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 31
# Your guess is too low.

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 34
# Your guess is too high.

# You have 2 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have 1 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have no more guesses. You lost!