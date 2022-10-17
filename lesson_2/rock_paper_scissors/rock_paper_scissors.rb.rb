require 'pry'

class Move
  VALUES = %w(rock paper scissors lizard spock)

  def to_s
    @value
  end

  def >(other_move)
    @defeats.include?(other_move.value)
  end
end

class Rock < Move
  attr_reader :value

  def initialize
    @value = 'rock'
    @defeats = ['scissors', 'lizard']
  end
end

class Paper < Move
  attr_reader :value

  def initialize
    @value = 'paper'
    @defeats = ['rock', 'spock']
  end
end

class Scissors < Move
  attr_reader :value

  def initialize
    @value = 'scissors'
    @defeats = ['paper', 'lizard']
  end
end

class Lizard < Move
  attr_reader :value

  def initialize
    @value = 'lizard'
    @defeats = ['paper', 'spock']
  end
end

class Spock < Move
  attr_reader :value

  def initialize
    @value = 'spock'
    @defeats = ['rock', 'scissors']
  end
end

class Player
  attr_reader :move
  attr_accessor :name, :score

  def initialize
    set_name
    @score = 0
  end

  def increment_score
    @score += 1
  end

  def move=(value)
    move_objects = {
      'rock' => Rock.new,
      'paper' => Paper.new,
      'scissors' => Scissors.new,
      'spock' => Spock.new,
      'lizard' => Lizard.new
    }
    @move = move_objects[value]
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard, or spock:"
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = choice
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move::VALUES.sample
  end
end

class R2D2 < Computer
  def set_name
    self.name = 'R2D2'
  end

  def choose
    self.move = 'rock'
  end
end

class Hal < Computer
  def set_name
    self.name = 'Hal'
  end

  # mostly scissors, never paper
  def choose
    rng = (1..10).to_a.sample
    choice =  if rng < 9
                'scissors'
              else
                %w(rock lizard spock).sample
              end
    self.move = choice
  end
end

class Chappie < Computer
  def set_name
    self.name = "Chappie"
  end

  # mostly lizard, never rock
  def choose
    rng = (1..10).to_a.sample
    choice =  if rng < 9
                'lizard'
              else
                %w(paper scissors spock).sample
              end
    self.move = choice
  end
end

class Sonny < Computer
  def set_name
    self.name = "Sonny"
  end

  # mostly spock or scissors
  def choose
    rng = (1..10).to_a.sample
    choice =  if rng < 9
                %w(spock scissors).sample
              else
                %w(rock paper lizard).sample
              end
    self.move = choice
  end
end

class Number5 < Computer
  def set_name
    self.name = "Number 5"
  end

  # mostly paper
  def choose
    rng = (1..10).to_a.sample
    choice =  if rng < 9
                'paper'
              else
                %w(rock scissors lizard spock).sample
              end
    self.move = choice
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = create_computer_player
    @current_moves = nil
    @move_history = []
  end

  def create_computer_player
    computer_name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
    computer_objects = {
      'R2D2' => R2D2.new,
      'Hal' => Hal.new,
      'Chappie' => Chappie.new,
      'Sonny' => Sonny.new,
      'Number 5' => Number5.new
    }
    computer_objects[computer_name]
  end

  def display_scores
    puts "#{human.name}: #{human.score} - #{computer.name}: #{computer.score}"
    puts ""
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    puts "First to win 10 games is the grand winner!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Good bye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def add_moves_to_current_moves
    @current_moves = "#{human.name} chose #{human.move}. " \
      "#{computer.name} chose #{computer.move}. "
  end

  def display_winner
    if human.move > computer.move
      @round_result = "#{human.name} won!"
      human.increment_score
    elsif computer.move > human.move
      @round_result = "#{computer.name} won!"
      computer.increment_score
    else
      @round_result = "It's a tie."
    end
    puts @round_result
  end

  def add_result_to_current_moves
    @current_moves << @round_result
  end

  def display_grand_winner_message
    if human.score >= 10
      puts "#{human.name} is the grand winner!!"
    elsif computer.score >= 10
      puts "#{computer.name} is the grand winner!!"
    end
  end

  def add_current_moves_to_move_history
    @move_history << @current_moves
  end

  def display_move_history
    puts "--- MOVE HISTORY ---"
    puts @move_history
    puts "--------------------"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end
    return true if answer == 'y'
    false
  end

  def game_over?
    human.score >= 10 || computer.score >= 10
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_moves
      add_moves_to_current_moves
      display_winner
      add_result_to_current_moves
      display_scores
      add_current_moves_to_move_history
      break if game_over?
    end
    display_grand_winner_message
    display_move_history
    display_goodbye_message
  end
end

RPSGame.new.play
