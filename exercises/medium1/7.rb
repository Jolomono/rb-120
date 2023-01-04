require 'pry'

class InvalidRangeError < StandardError; end

class GuessingGame
  attr_accessor :current_guess, :guesses
  attr_reader :solution, :range

  def initialize(min, max)
    if min > max
      raise InvalidRangeError, "Min range must be less than Max Range. Current values: Min: #{min} Max: #{max}"
    end
    @range = (min..max)
    @solution = range.to_a.sample
    @guesses = calculate_guesses
  end

  def calculate_guesses
    Math.log2(range.size).to_i + 1
  end

  def game_over?
    player_won? || player_lost?
  end

  def player_won?
    current_guess == solution
  end

  def player_lost?
    guesses == 0
  end

  def player_guess
    choice = nil
    loop do
      print "Enter a number between #{range.min} and #{range.max}: "
      choice = gets.chomp
      break if valid_choice?(choice)
      puts "Invalid guess."
    end
    self.current_guess = choice.to_i
    self.guesses -= 1 unless player_won?
  end

  def display_guess_result
    if current_guess > solution
      puts "Your guess is too high."
      puts ""
    elsif current_guess < solution
      puts "Your guess is too low."
      puts ""
    end
  end

  def valid_choice?(choice)
    choice == choice.to_i.to_s && range.cover?(choice.to_i)
  end

  def display_remaining_guesses
    if guesses == 1
      puts "You have 1 guess remaining."
    else
      puts "You have #{guesses} guesses remaining."
    end
  end

  def display_result
    if player_won?
      puts "That's the number!"
      puts ""
      puts "You won!"
    else
      puts "You have no more guesses. You lost!"
      puts "The number was: #{solution}"
    end
  end

  def play
    until game_over?
      display_remaining_guesses
      player_guess
      display_guess_result
    end
    display_result
  end

end

game = GuessingGame.new(50, 5)
game.play
