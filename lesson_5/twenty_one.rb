class Deck
  def initialize
    @cards = []
    create_deck
    shuffle_deck!
  end

  def deal_card
    cards.pop
  end

  private

  attr_accessor :cards

  CARD_FACES = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
  SUITS = %w(Hearts Spades Clubs Diamonds)

  def create_deck
    CARD_FACES.each do |face|
      SUITS.each do |suit|
        cards << Card.new(face, suit)
      end
    end
  end

  def shuffle_deck!
    cards.shuffle!
  end
end

class Card
  attr_reader :value, :face

  def ace?
    face == 'Ace'
  end

  private

  attr_writer :value

  # card values at initialization of deck (Ace is always 11 to start)
  CARD_VALUES = {
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    '10' => 10,
    'Jack' => 10,
    'Queen' => 10,
    'King' => 10,
    'Ace' => 11
  }
  def initialize(face, suit)
    @face = face
    @suit = suit
    @value = CARD_VALUES[face]
  end
end

class Player
  attr_reader :hand

  def score
    calculate_score
  end

  def ace_in_hand?
    hand.any?(&:ace?)
  end

  def display_hand
    cards = ""
    hand.each do |card|
      cards << card.face
      cards << " and " unless card == hand.last
    end
    cards
  end

  # only used for dealer - keeps first card hidden
  def display_dealer_opening_hand
    hand[1].face
  end

  def display_dealt_card
    hand.last.face.to_s
  end

  def clear_hand
    @hand = []
  end

  def place_new_card_in_hand(card)
    hand << card
  end

  private

  def initialize
    @hand = []
  end

  def calculate_score
    score = 0
    hand.each do |card|
      score += card.value
    end
    select_all_aces.size.times do
      break if score <= 21
      score -= 10
    end
    score
  end

  def select_all_aces
    hand.select(&:ace?)
  end
end

# orchestration engine
class TwentyOneGame
  attr_accessor :player_wins, :dealer_wins

  def play
    clear_terminal
    display_welcome_message
    loop do
      main_game
      break if player_wins == 5 || dealer_wins == 5
      break unless play_again?
      clear_terminal
    end
    display_goodbye_message
  end

  private

  BUSTING_SCORE = 22
  DEALER_STOP_HITTING_SCORE = 17

  attr_accessor :deck
  attr_reader :human, :dealer

  def initialize
    @deck = Deck.new
    @human = Player.new
    @dealer = Player.new
    @player_wins = 0
    @dealer_wins = 0
  end

  def main_game
    opening_hand
    player_turn
    dealer_turn unless bust?(human)
    tally_win
    display_results
    display_total_game_score
    reset_game
  end

  def opening_hand
    deal_opening_hand
    display_opening_hand
    display_player_score
  end

  def deal_opening_hand
    2.times do
      human.place_new_card_in_hand(deck.deal_card)
      dealer.place_new_card_in_hand(deck.deal_card)
    end
  end

  def display_opening_hand
    prompt "Dealing cards...\n\n"
    prompt "Your hand: #{human.display_hand}"
    prompt "Dealer's hand: [Face-Down] and \
#{dealer.display_dealer_opening_hand}\n\n"
  end

  def player_turn
    loop do
      break unless hit?
      player_hit
      break if bust?(human)
    end
  end

  def tally_win
    if bust?(human)
      self.dealer_wins += 1
    elsif bust?(dealer)
      self.player_wins += 1
    elsif human.score > dealer.score
      self.player_wins += 1
    elsif dealer.score > human.score
      self.dealer_wins += 1
    end
  end

  def display_results
    handle_bust
    handle_win
    handle_tie
  end

  def handle_bust
    if bust?(human)
      display_player_bust_message
    elsif bust?(dealer)
      display_dealer_bust_message
    end
  end

  def handle_win
    return if bust?(human) || bust?(dealer)
    if human.score > dealer.score
      display_card_comparison
      display_player_wins_message
    elsif dealer.score > human.score
      display_card_comparison
      display_dealer_wins_message
    end
  end

  def handle_tie
    display_tie_message if dealer.score == human.score
  end

  def play_again?
    choice = ''
    prompt "Would you like to play again? ('y' or 'n')"
    loop do
      choice = gets.chomp.downcase
      puts ""
      break if %w(y n).include?(choice)
      prompt "Sorry that's an invalid choice. Please enter 'y' or 'n'."
    end
    choice == 'y'
  end

  def reset_game
    reset_deck
    reset_hands
  end

  def reset_deck
    @deck = Deck.new
  end

  def reset_hands
    human.clear_hand
    dealer.clear_hand
  end

  def display_card_comparison
    prompt "Your cards add up to #{human.score} and the Dealer's cards \
add up to #{dealer.score}."
  end

  def display_total_game_score
    prompt "The score is:"
    prompt "Player: #{player_wins}"
    prompt "Dealer: #{dealer_wins}\n\n"
  end

  def display_player_wins_message
    prompt "You win!\n\n"
  end

  def display_dealer_wins_message
    prompt "The Dealer wins!\n\n"
  end

  def display_tie_message
    prompt "It's a tie!\n\n"
  end

  def player_hit
    human.place_new_card_in_hand(deck.deal_card)
    display_player_dealt_card
    display_player_score
  end

  def hit?
    choice = nil
    loop do
      prompt "Would you like to hit or stay? ('h' or 's')"
      choice = gets.chomp.downcase
      puts ""
      break if %w(h s).include?(choice)
      prompt "Sorry that is an invalid choice. Please enter 'h' or 's'.\n\n"
    end
    choice == 'h'
  end

  def bust?(player)
    player.score >= BUSTING_SCORE
  end

  def display_player_bust_message
    prompt "You busted! The Dealer wins.\n\n"
  end

  def display_dealer_bust_message
    prompt "The Dealer busted! You win.\n\n"
  end

  def display_player_dealt_card
    prompt "You are dealt a #{human.display_dealt_card}."
  end

  def dealer_turn
    dealer_turns_over_first_card
    display_dealer_score
    loop do
      dealer_makes_move
      break if dealer_stay?
    end
  end

  def dealer_turns_over_first_card
    prompt "The Dealer turns over her first card..."
    prompt "The Dealer has #{dealer.display_hand}.\n\n"
  end

  def dealer_makes_move
    dealer_stay? ? display_dealer_stay : dealer_hit
  end

  def dealer_hit
    prompt "The Dealer draws..."
    dealer.place_new_card_in_hand(deck.deal_card)
    display_dealer_dealt_card
    display_dealer_score
  end

  def display_dealer_stay
    prompt "The Dealer stays...\n\n"
  end

  def dealer_stay?
    dealer.score >= DEALER_STOP_HITTING_SCORE
  end

  def display_dealer_dealt_card
    prompt "The Dealer is dealt a #{dealer.display_dealt_card}."
  end

  def display_player_score
    prompt "Your cards add up to #{human.score}.\n\n"
  end

  def display_dealer_score
    prompt "The Dealer's cards add up to #{dealer.score}.\n\n"
  end

  def prompt(message)
    puts ">>> #{message}"
  end

  def display_welcome_message
    prompt "Welcome to 21!"
  end

  def display_goodbye_message
    prompt "Thanks for playing 21. Goodbye!\n\n"
  end

  def clear_terminal
    system('clear') || system('cls')
  end
end

game = TwentyOneGame.new
game.play
