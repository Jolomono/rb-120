require 'pry'

class Deck
  attr_reader :contents

  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    create_deck
  end

  def create_deck
    @contents = []
    RANKS.each do |rank|
      SUITS.each do |suit|
        contents << Card.new(rank, suit)
      end
    end
    contents.shuffle!
  end

  def draw
    create_deck if contents.empty?
    contents.shift
  end
end

class Card
  include Comparable
  attr_reader :rank, :suit

  VALUES = { 'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14 }

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def value
    VALUES.fetch(rank, rank)
  end

  def <=>(other_card)
    value <=> other_card.value
  end
end

# Include Card and Deck classes from the last two exercises.

class PokerHand
  attr_reader :cards

  def initialize(deck)
    @cards = []
    5.times { @cards << deck.draw }
  end

  def print
    puts cards
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

  def royal_flush?
    cards.min.rank == 10 && straight_flush?
  end

  def straight_flush?
    flush? && straight?
  end

  def four_of_a_kind?
    card_values = cards.collect(&:value)
    card_values.uniq.each do |value|
      return true if card_values.count(value) == 4
    end
    false
  end

  def full_house?
    card_values = cards.collect(&:value)
    card_counts = card_values.uniq.collect do |value|
                    card_values.count(value)
                  end
    card_counts.include?(2) && card_counts.include?(3)
  end

  def flush?
    card_suits = cards.collect(&:suit)
    card_suits.count(card_suits.first) == 5
  end

  def straight?
    card_values = cards.collect(&:value).sort
    (0...card_values.size - 1).each do |idx|
      return false unless card_values[idx] + 1 == card_values[idx + 1]
    end
    true
  end

  def three_of_a_kind?
    card_values = cards.collect(&:value)
    card_values.uniq.each do |value|
      return true if card_values.count(value) == 3
    end
    false
  end

  def two_pair?
    card_values = cards.collect(&:value)
    card_counts = card_values.uniq.collect do |value|
                    card_values.count(value)
                  end
    card_counts.count(2) == 2
  end

  def pair?
    card_values = cards.collect(&:value)
    card_values.uniq.each do |value|
      return true if card_values.count(value) == 2
    end
    false
  end
end

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

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