class GuessingGame

  def initialize(bottom, top)
    @secret_number = nil
    @range = (bottom..top)
    @size_of_range = range.size
    @maximum_number_of_guesses = Math.log2(size_of_range).to_i + 1
    @current_guess = nil
  end

  def play
    system 'clear'
    reset
    determine_secret_number
    main_game_loop
    display_result
  end

  private

  attr_reader :current_guess, :secret_number, :size_of_range, :range,
              :maximum_number_of_guesses

  def prompt(message)
    puts ">>> #{message}"
  end

  def reset
    @secret_number = nil
    @current_guess = nil
  end

  def main_game_loop
    maximum_number_of_guesses.downto(1) do |guesses_remaining|
      display_guesses_remaining(guesses_remaining)
      ask_for_number
      evaluate_guess
      break if current_guess == secret_number
    end
  end

  def determine_secret_number
    @secret_number = rand(range)
  end

  def display_guesses_remaining(number_of_guesses)
    if number_of_guesses > 1
      prompt "You have #{number_of_guesses} guesses remaining."
    else
      prompt "You have 1 guess remaining."
    end
  end

  def ask_for_number
    print ">>> Enter a number between #{range.first} and #{range.last}: "
    loop do
      @current_guess = gets.chomp.to_i
      break if (range).cover?(current_guess)
      print ">>> Invalid Guess. Enter a number between #{range.first} and #{range.last}: "
    end
  end

  def evaluate_guess
    if current_guess < secret_number
      prompt "Your guess is too low."
    elsif current_guess > secret_number
      prompt "Your guess is too high."
    else
      prompt "That's the number!"
    end
    puts ""
  end

  def display_result
    if current_guess == secret_number
      prompt "You won!"
    else
      prompt "You have no more guesses. You lost!"
    end
    puts ""
  end

end

game = GuessingGame.new(1, 1500)
game.play
game.play

# You have 10 guesses remaining.
# Enter a number between 501 and 1500: 104
# Invalid guess. Enter a number between 501 and 1500: 1000
# Your guess is too low.

# You have 9 guesses remaining.
# Enter a number between 501 and 1500: 1250
# Your guess is too low.

# You have 8 guesses remaining.
# Enter a number between 501 and 1500: 1375
# Your guess is too high.

# You have 7 guesses remaining.
# Enter a number between 501 and 1500: 80
# Invalid guess. Enter a number between 501 and 1500: 1312
# Your guess is too low.

# You have 6 guesses remaining.
# Enter a number between 501 and 1500: 1343
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 501 and 1500: 1359
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 501 and 1500: 1351
# Your guess is too high.

# You have 3 guesses remaining.
# Enter a number between 501 and 1500: 1355
# That's the number!

# You won!

# game.play
# You have 10 guesses remaining.
# Enter a number between 501 and 1500: 1000
# Your guess is too high.

# You have 9 guesses remaining.
# Enter a number between 501 and 1500: 750
# Your guess is too low.

# You have 8 guesses remaining.
# Enter a number between 501 and 1500: 875
# Your guess is too high.

# You have 7 guesses remaining.
# Enter a number between 501 and 1500: 812
# Your guess is too low.

# You have 6 guesses remaining.
# Enter a number between 501 and 1500: 843
# Your guess is too high.

# You have 5 guesses remaining.
# Enter a number between 501 and 1500: 820
# Your guess is too low.

# You have 4 guesses remaining.
# Enter a number between 501 and 1500: 830
# Your guess is too low.

# You have 3 guesses remaining.
# Enter a number between 501 and 1500: 835
# Your guess is too low.

# You have 2 guesses remaining.
# Enter a number between 501 and 1500: 836
# Your guess is too low.

# You have 1 guesses remaining.
# Enter a number between 501 and 1500: 837
# Your guess is too low.

# You have no more guesses. You lost!
