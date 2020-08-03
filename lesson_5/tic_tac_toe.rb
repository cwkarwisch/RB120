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
  MIDDLE_SQUARE = 5
  CORNERS = [1, 3, 7, 9]

  attr_reader :squares

  def initialize
    @squares = {}
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def reset
    (1..9).each do |key|
      @squares[key].marker = Square::INITIAL_MARKER
    end
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
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
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

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

  def winning_line?(marker)
    WINNING_MOVES.any? do |moves|
      moves.all? { |position| squares[position].marker == marker }
    end
  end

  def full?
    squares.none? { |_, square| square.empty? }
  end

  def middle_square_open?
    squares[MIDDLE_SQUARE].marker == Square::INITIAL_MARKER
  end

  def winning_move_available?(marker_being_checked)
    WINNING_MOVES.any? do |line|
      winning_move_in_line?(line, marker_being_checked)
    end
  end

  def winning_move_in_line?(line, marker_being_checked)
    marker_being_checked_count = 0
    empty_marker_count = 0
    line.each do |position|
      if squares[position].marker == marker_being_checked
        marker_being_checked_count += 1
      elsif squares[position].marker == Square::INITIAL_MARKER
        empty_marker_count += 1
      end
    end
    marker_being_checked_count == 2 && empty_marker_count == 1 ? true : false
  end

  def find_winning_move(marker_being_checked)
    WINNING_MOVES.each do |line|
      if winning_move_in_line?(line, marker_being_checked)
        line.each do |position|
          if squares[position].marker == Square::INITIAL_MARKER
            return position
          end
        end
      end
    end
  end

  def corner_available?
    open_moves = empty_board_positions
    CORNERS.any? do |corner|
      open_moves.include?(corner)
    end
  end

  def unmarked_corners
    empty_board_positions.select do |position|
      CORNERS.include?(position)
    end
  end

  private

  def join_with_or(array)
    return array[0].to_s if array.size == 1
    list = array.clone
    last_item = list.pop
    "#{list.join(', ')}, or #{last_item}"
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def empty?
    marker == INITIAL_MARKER
  end

  def to_s
    marker
  end
end

Player = Struct.new(:marker, :score, :name)

class TTTGame
  def play
    display_welcome_message
    main_game
    display_goodbye_message
  end

  private

  attr_accessor :winner, :current_player, :first_to_move
  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(nil, 0, nil)
    @computer = Player.new(nil, 0, nil)
    @winner = nil
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

  def choose_first_to_move
    choice = nil
    loop do
      prompt "Which player should make the first move?"
      prompt "Enter 'u' for the user, 'c' for the computer, or 'r' for random."
      choice = gets.chomp.downcase
      puts ""
      break if %w(u c r).include?(choice)
      prompt "That's an invalid choice. Enter 'u', 'c', or 'r'.\n\n"
    end
    save_first_to_move(choice)
  end

  def save_first_to_move(choice)
    case choice
    when 'u' then self.first_to_move = human
    when 'c' then self.first_to_move = computer
    when 'r' then self.first_to_move = [human, computer].sample
    end
    self.current_player = first_to_move
  end

  def choose_marker
    choice = nil
    loop do
      prompt "What marker would you like to use? 'X' or 'O'?"
      choice = gets.chomp.downcase
      puts ""
      break if %w(x o).include?(choice)
      prompt "That's an invalid choice. Enter 'X' or 'O'."
      puts ""
    end
    save_marker_choice(choice)
  end

  def save_marker_choice(choice)
    case choice
    when 'x'
      human.marker = 'X'
      computer.marker = 'O'
    when 'o'
      human.marker = 'O'
      computer.marker = 'X'
    end
  end

  def choose_names
    choose_player_name
    choose_computer_name
  end

  def choose_player_name
    choice = nil
    loop do
      prompt "What's your name?"
      choice = gets.chomp
      puts ""
      break if !choice.empty?
      prompt "That's an invalid choice. Please enter your name."
      puts ""
    end
    human.name = choice
  end

  def choose_computer_name
    choice = nil
    loop do
      prompt "What would you like the computer's name to be?"
      choice = gets.chomp
      puts ""
      break if !choice.empty?
      prompt "That's an invalid choice. Please enter a name for the computer."
      puts ""
    end
    computer.name = choice
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

  def main_game
    user_choices
    loop do
      display_board
      player_move
      display_result
      display_score
      break if human.score == 5 || computer.score == 5
      break unless play_again?
      reset
    end
  end

  def user_choices
    choose_names
    choose_first_to_move
    choose_marker
  end

  def display_score
    prompt "The score is:"
    prompt "#{human.name}: #{human.score}"
    prompt "#{computer.name}: #{computer.score}"
    puts ""
  end

  def player_move
    loop do
      current_player_moves
      detect_winner
      clear_screen_and_display_board if human_turn?
      break if winner? || board.full?
    end
  end

  def human_moves
    prompt "Choose a square from the following: \
#{board.list_of_open_board_positions}"
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
    if board.winning_move_available?(computer.marker)
      computer_winning_move
    elsif board.winning_move_available?(human.marker)
      computer_defensive_move
    elsif board.corner_available?
      computer_mark_random_corner
    else
      computer_random_move
    end
  end

  def computer_opening_move
    board[Board::MIDDLE_SQUARE] = computer.marker
  end

  def computer_winning_move
    board[board.find_winning_move(computer.marker)] = computer.marker
  end

  def computer_defensive_move
    board[board.find_winning_move(human.marker)] = computer.marker
  end

  def computer_mark_random_corner
    board[board.unmarked_corners.sample] = computer.marker
  end

  def computer_random_move
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
    if board.winning_line?(human.marker)
      self.winner = human
      human.score += 1
    elsif board.winning_line?(computer.marker)
      self.winner = computer
      computer.score += 1
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
    self.current_player = if human_turn?
                            computer
                          else
                            human
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
