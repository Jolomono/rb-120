require 'pry'

module Hand
  def ace?
    card_names = hand.collect(&:name)
    card_names.include?('A')
  end

  def hand_value
    card_values = hand.collect(&:value)
    hand_value = card_values.sum
    hand_value += 10 if ace? && hand_value + 10 <= Game::WINNING_SCORE
    hand_value
  end
end

class Deck
  attr_reader :cards

  FACE_CARDS = ['J', 'Q', 'K']

  def initialize
    @cards = create_deck
  end

  def deal_starting_hands(player, dealer)
    deal_cards_to(player, 2)
    deal_cards_to(dealer, 2)
  end

  def deal_card_to(participant)
    deal_cards_to(participant, 1)
  end

  private

  def deal_cards_to(recipient, num_cards)
    current_cards = cards.shift(num_cards)
    recipient.hand += current_cards
  end

  def create_deck
    deck = []
    %w(2 3 4 5 6 7 8 9 10 J Q K A).each do |card_name|
      4.times { deck << Card.new(card_name) }
    end
    deck.shuffle
  end
end

class Card
  attr_reader :name, :value

  def initialize(name)
    @name = name
    @value = set_value
  end

  def to_s
    @name
  end

  def set_value
    case name
    when name.to_i.to_s then name.to_i
    when *Deck::FACE_CARDS then 10
    else 1
    end
  end
end

class Participant
  attr_accessor :hand

  include Hand

  def initialize
    @hand = []
  end

  def busted?
    hand_value > Game::WINNING_SCORE
  end
end

class Player < Participant
  # can make choices to hit or stay
  def display_hand
    delimiter = ", "
    prefix = "You have:"
    value_str = "Worth: #{hand_value}"
    if hand.size == 2
      puts "#{prefix} #{hand.first} and #{hand.last}. #{value_str}"
    else
      start_str = hand.slice(0..-2).join(delimiter)
      end_str = " #{hand[-1]}"
      puts "#{prefix} #{start_str}#{delimiter}and#{end_str}. #{value_str}"
    end
  end

  def hit?
    choice = ''
    loop do
      puts ""
      puts "=> Hit or stay? (h or s)"
      choice = gets.chomp.downcase
      break if %w(h s).include?(choice)
      puts "Invalid choice, please type 'h' for hit or 's' for stay."
    end
    choice == 'h'
  end
end

class Dealer < Participant
  def display_hand
    prefix = "Dealer has: #{hand.first} and "
    if hand.size == 2
      puts prefix + "1 unknown card."
    else
      puts prefix + "#{hand.size - 1} unknown cards."
    end
  end

  def display_full_hand
    delimiter = ", "
    prefix = "Dealer has:"
    value_str = "Worth: #{hand_value}"
    if hand.size == 2
      puts "#{prefix} #{hand.first} and #{hand.last}. #{value_str}"
    else
      start_str = hand.slice(0..-2).join(delimiter)
      end_str = " #{hand[-1]}"
      puts "#{prefix} #{start_str}#{delimiter}and#{end_str}. #{value_str}"
    end
  end

  def hit?
    hand_value < Game::DEALER_STAY
  end
end

class Game
  attr_reader :deck, :player, :dealer

  WINNING_SCORE = 21
  DEALER_STAY = 17

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def deal_hands
    deck.deal_starting_hands(player, dealer)
  end

  def show_initial_cards
    player.display_hand
    dealer.display_hand
  end

  def show_final_cards
    puts ""
    player.display_hand
    dealer.display_full_hand
  end

  def player_turn
    loop do
      if player.busted?
        puts ""
        puts "You have busted!"
        break
      end
      break unless player.hit?
      deck.deal_card_to(player)
      player.display_hand
    end
  end

  def dealer_turn
    puts ""
    dealer.display_full_hand
    loop do
      if dealer.busted?
        display_dealer_busted_message
        break
      end
      break unless dealer.hit?
      dealer_hits
    end
  end

  def display_dealer_busted_message
    puts ""
    puts "Dealer has busted!"
  end

  def dealer_hits
    puts ""
    puts "Dealer will hit."
    sleep(1)
    deck.deal_card_to(dealer)
    dealer.display_full_hand
    sleep(1)
  end

  def winner
    if player.busted? then dealer
    elsif dealer.busted? then player
    elsif player.hand_value > dealer.hand_value then player
    elsif dealer.hand_value > player.hand_value then dealer
    end
  end

  def someone_busted?
    player.busted? || dealer.busted?
  end

  def show_result
    show_final_cards unless someone_busted?
    case winner
    when player
      puts "You have won!"
    when dealer
      puts "Dealer has won!"
    else
      puts "It is a tie. No winner."
    end
  end

  def play
    deal_hands
    show_initial_cards
    player_turn
    dealer_turn unless player.busted?
    show_result
  end
end

game = Game.new
game.play
