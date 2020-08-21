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

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
puts drawn.count { |card| card.rank == 5 } == 4
puts drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
puts drawn != drawn2 # Almost always.
puts drawn2.count { |card| card.rank == 10 } == 4
puts drawn2.count { |card| card.suit == 'Spades' } == 13
