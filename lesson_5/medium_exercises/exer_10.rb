class PokerHand
  def initialize(deck)
    @hand = []
    @ranks_in_hand = Hash.new(0)
    5.times do
      card = deck.draw
      hand << card
      ranks_in_hand[card.rank] += 1
    end
  end

  def print
    puts hand
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  attr_reader :hand, :ranks_in_hand

  def royal_flush?
    straight_flush? && hand.min.rank == 10
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    ranks_in_hand.any? do |_, count|
      count == 4
    end
  end

  def full_house?
    ranks_in_hand.has_value?(3) && ranks_in_hand.has_value?(2)
  end

  def flush?
    suit = hand[0].suit
    hand.all? { |card| card.suit == suit}
  end

  def straight?
    sorted_hand = hand.sort
    (sorted_hand[0].value + 1) == sorted_hand[1].value &&
    (sorted_hand[1].value + 1) == sorted_hand[2].value &&
    (sorted_hand[2].value + 1) == sorted_hand[3].value &&
    (sorted_hand[3].value + 1) == sorted_hand[4].value
  end

  def three_of_a_kind?
    ranks_in_hand.any? do |_, count|
      count == 3
    end
  end

  def two_pair?
    ranks_in_hand.select { |_, count| count == 2 }.size == 2
  end

  def pair?
    ranks_in_hand.any? do |_, count|
      count == 2
    end
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    @deck = create_deck.shuffle
  end

  def create_deck
    new_deck = []
    RANKS.each do |rank|
      SUITS.each do |suit|
        new_deck << Card.new(rank, suit)
      end
    end
    new_deck
  end

  def size
    deck.size
  end

  def draw
    if deck.size > 0
      deck.pop
    else
      reset_deck
      deck.pop
    end
  end

  def to_s
    string = ""
    deck.each do |card|
      string << (card.to_s + " ")
    end
    string
  end

  attr_accessor :deck

  private

  def reset_deck
    self.deck = create_deck.shuffle
  end

end

class Card
  # include Comparable

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def <=>(other)
    return -1 if RANKING[rank] < RANKING[other.rank]
    return 0 if RANKING[rank] == RANKING[other.rank]
    return 1 if RANKING[rank] > RANKING[other.rank]
  end

  def ==(other)
    rank == other.rank && suit == other.suit
  end

  def value
    RANKING[rank]
  end

  private

  RANKING = {
    2 => 2,
    3 => 3,
    4 => 4,
    5 => 5,
    6 => 6,
    7 => 7,
    8 => 8,
    9 => 9,
    10 => 10,
    'Jack' => 11,
    'Queen' => 12,
    'King' => 13,
    'Ace' => 14,
  }
end

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'

# 5 of Clubs
# 7 of Diamonds
# Ace of Hearts
# 7 of Clubs
# 5 of Spades
# Two pair
# true
# true
# true
# true
# true
# true
# true
# true
# true
# true
# true
# true
# true
