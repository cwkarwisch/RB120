=begin

- In TTT, we start with an empty board with 9 spaces.

- There are two moves, but each player can only make one kind
  of moce, either x or o.

- Each player takes a turn making a move.

- A player wins when they have made three moves that form a
  straight line on the board. There are 8 possible winning
  combinations. 3 horizontal, 3 vertical, and 2 diagonal.

- When a player makes a move, the board is updated to
  show which square the player marked.

Nouns:
  - board
  - move

Verbs:
  - mark
  - start
  - straight line

=end

require 'pry'

class Board
  WINNING_MOVES = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
    [1, 4, 7],
    [2, 5, 8],
    [3, 6, 9],
    [1, 5, 9],
    [3, 5, 7]
  ]

  attr_reader :squares

  def initialize
    @squares = {}
    (1..9).each { |key| @squares[key] = Square.new}
  end

  def reset
    (1..9).each do |key|
      @squares[key].marker = Square::INITIAL_MARKER
    end
  end

  def draw
    puts "          |     |"
    puts "       #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}"
    puts "          |     |"
    puts "     -----+-----+-----"
    puts "          |     |"
    puts "       #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}"
    puts "          |     |"
    puts "     -----+-----+-----"
    puts "          |     |"
    puts "       #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}"
    puts "          |     |"
  end

  def []=(board_position, marker)
    squares[board_position].marker = marker
  end

  def empty_board_positions
    squares.keys.select do |board_position|
      squares[board_position].marker == " "
    end
  end

  def list_of_open_board_positions
    open_moves = squares.keys.select do |board_position|
      squares[board_position].empty?
    end
    join_with_or(open_moves)
  end

  def join_with_or(array)
    return "#{array[0]}" if array.size == 1
    list = array.clone
    last_item = list.pop
    "#{list.join(', ')}, or #{last_item}"
  end

  def winning_line?(marker)
    WINNING_MOVES.any? do |moves|
      moves.all? { |position| squares[position].marker == marker }
    end
  end

  def full?
    squares.none? { |_, square| square.empty?}
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    # maybe a "status" to keep track of this square's mark?
    @marker = marker
  end

  def empty?
    marker == INITIAL_MARKER
  end

  def to_s
    marker
  end

end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  def play
    display_welcome_message

    loop do
      display_board

      loop do
        current_player_moves
        detect_winner
        clear_screen_and_display_board if human_turn?
        break if winner? || board.full?
      end

      display_result
      break unless play_again?
      reset
    end

    display_goodbye_message
  end

  private

  HUMAN_MARKER = 'O'
  COMPUTER_MARKER = 'X'

  attr_accessor :winner, :current_player
  attr_reader :board, :human, :computer, :first_to_move

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @winner = nil
    @first_to_move = human
    @current_player = first_to_move
  end

  def prompt(message)
    puts ">>> #{message}"
  end

  def clear_terminal
    system("clear") || system("cls")
  end

  def display_welcome_message
    clear_terminal
    prompt "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    prompt "Thank you for playing Tic Tac Toe! Goodbye."
    puts ""
  end

  def display_board
    prompt "You're a #{human.marker} and the computer is a #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear_terminal
    display_board
  end

  def human_moves
    prompt "Choose a square from the following: #{board.list_of_open_board_positions}"
    choice = ""
    loop do
      choice = gets.chomp.to_i
      break if board.empty_board_positions.include?(choice.to_i)
      puts ""
      prompt "Sorry. That's not a valid choice."
    end
    board[choice] = human.marker
    puts " "
  end

  def computer_moves
    choice = board.empty_board_positions.sample
    board[choice] = computer.marker
  end

  def display_result
    clear_screen_and_display_board
    case winner
    when nil then prompt "The board is full. It's a tie."
    when human then prompt "You won!"
    when computer then prompt "The computer won!"
    end
    puts ""
  end

  def winner?
    winner != nil
  end

  def detect_winner
    if board.winning_line?(HUMAN_MARKER)
      self.winner = human
    elsif board.winning_line?(COMPUTER_MARKER)
      self.winner = computer
    end
  end

  def play_again?
    prompt "Would you like to play again? (y or n)"
    choice = ""
    loop do
      choice = gets.chomp.downcase
      puts ""
      break if ['y', 'n'].include?(choice)
      prompt "Sorry. That's not a valid selection. Please enter 'y' or 'n'."
    end
    clear_terminal if choice == 'y'
    choice == 'y'
  end

  def reset_winner
    self.winner = nil
  end

  def reset
    board.reset
    reset_winner
    self.current_player = first_to_move
  end

  def flip_current_player
    if human_turn?
      self.current_player = computer
    else
      self.current_player = human
    end
  end

  def human_turn?
    current_player == human
  end

  def current_player_moves
    if human_turn?
      human_moves
    else
      computer_moves
    end
    flip_current_player
  end
end

game = TTTGame.new
game.play
