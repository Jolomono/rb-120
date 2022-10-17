require 'pry'

# relies on accessing a Board object named 'board'
module CpuLogic
  # if there's a line where you can add a third marker, that's the best line
  # otherwise, if there's a line where you can block the human,
  # that's the best line
  # otherwise pick center square, or a random available square index
  def detect_best_index
    best_line = detect_best_line
    best_line ||= detect_best_line('block')

    if best_line
      best_line.select { |key| board.squares[key].unmarked? }.first
    elsif board.squares[5].unmarked?
      5
    else
      board.unmarked_keys.sample
    end
  end

  # does a row have exactly one unmarked space?
  # does that row have two human markers?
  # does that row have two computer markers?
  def detect_best_line(goal = 'win')
    marker = goal == 'win' ? computer.marker : human.marker
    Board::WINNING_LINES.each do |line|
      line_squares = board.squares.values_at(*line)
      marked_squares = line_squares.select(&:marked?)
      next unless marked_squares.size == 2
      if marked_squares.collect(&:marker).count(marker) == 2
        return line
      end
    end
    nil
  end

  def detect_winning_line
    Board::WINNING_LINES.each do |line|
      line_squares = board.squares.values_at(*line)
      marked_squares = line_squares.select(&:marked?)
      next unless marked_squares.size == 2
      if marked_squares.collect(&:marker).count(computer.marker) == 2
        return line
      end
    end
    nil
  end
end

module Displayable
  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear
    system 'clear'
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "#{human.name} is #{human.marker}. #{computer.name} is " \
         "#{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def display_score
    puts ""
    puts "-- Current Score --"
    puts "#{human.name}: #{human.score} | #{computer.name}: #{computer.score}"
    puts ""
  end

  def display_result
    winning_marker = board.detect_winning_marker
    increment_score(winning_marker)
    case winning_marker
    when human.marker
      puts "#{human.name} won!"
    when computer.marker
      puts "#{computer.name} won!"
    else
      puts "It's a tie."
    end
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  attr_reader :squares

  def initialize
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def set_square_at(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!detect_winning_marker
  end

  def three_of_the_same_marker?(line_squares)
    marked_squares = line_squares.select(&:marked?)
    return false if marked_squares.size < 3
    markers = marked_squares.collect(&:marker)
    markers.count(markers[0]) == 3
  end

  # returns winning marker or nil
  def detect_winning_marker
    WINNING_LINES.each do |line|
      line_squares = @squares.values_at(*line)
      if three_of_the_same_marker?(line_squares)
        return line_squares.first.marker
      end
    end
    nil
  end

  def get_available_spaces_string(delimiter = ', ', conjunction = 'or')
    array = unmarked_keys
    return "" if array.empty?
    return array[0] if array.length == 1
    start_str = array.slice(0..-2).join(delimiter)
    end_str = " #{array[-1]}"
    start_str + delimiter + conjunction + end_str
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize
    @marker = INITIAL_MARKER
  end

  def to_s
    @marker
  end

  def unmarked?
    @marker == INITIAL_MARKER
  end

  def marked?
    @marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker, :score, :name

  def initialize
    @score = 0
  end

  def increment_score
    @score += 1
  end
end

class Human < Player
  def choose_marker
    choice = nil
    loop do
      puts "=> Which marker would you like? ('X' or 'O')"
      choice = gets.chomp.upcase
      break if %w(X O).include?(choice)
      puts "Invalid response. Please select 'X' or 'O'."
    end
    @marker = choice
  end

  def choose_name
    choice = nil
    loop do
      puts "=> What is your name?"
      choice = gets.chomp
      break if !choice.empty?
      puts "Name must be at least 1 character long!"
    end
    @name = choice
  end
end

class Computer < Player
  NAMES = ["Bender", "Calculon", "Roberto", "Hedonism Bot", "Clamps"]

  attr_writer :marker

  # def set_marker(marker)
  #   @marker = marker
  # end

  def set_name
    @name = NAMES.sample
  end
end

class TTTGame
  WINNING_SCORE = 3

  include CpuLogic, Displayable

  attr_reader :board, :human, :computer

  private

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
  end

  def human_moves
    square = nil
    puts "Choose a square (#{board.get_available_spaces_string}):"
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    board.set_square_at(square, human.marker)
  end

  def computer_moves
    index = detect_best_index
    board.set_square_at(index, computer.marker)
  end

  def current_player_moves
    if @current_player == human
      human_moves
      @current_player = computer
    else
      computer_moves
      @current_player = human
    end
  end

  def end_round
    clear_screen_and_display_board
    display_result
    display_score
  end

  def increment_score(winning_marker)
    if winning_marker == human.marker
      human.increment_score
    elsif winning_marker == computer.marker
      computer.increment_score
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end
    answer == 'y'
  end

  def game_won?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
  end

  def end_of_game
    if human.score == WINNING_SCORE
      puts "#{human.name} is the grand winner with #{WINNING_SCORE} wins!"
    else
      puts "#{computer.name} is the grand winner with #{WINNING_SCORE} wins!"
    end
    sleep(2)
  end

  def reset
    board.reset
    clear
  end

  def starting_player_set
    @current_player = @starting_player
  end

  def choose_starting_player
    answer = ''
    loop do
      puts "=> Who goes first? (Type 'P' for Player, 'C' for Computer, " \
           "or 'Z' let the computer choose the starting player)"
      answer = gets.chomp.downcase
      break if %w(p c z).include?(answer)
      puts "=> Invalid choice. Please select 'P', 'C', or 'Z'"
    end
    self.starting_player = answer
  end

  def starting_player=(prompt_response)
    @starting_player =  case prompt_response
                        when 'p' then human
                        when 'c' then computer
                        when 'z'
                          shuffle = [human, computer].sample
                          shuffle
                        end
  end

  def play_round
    starting_player_set
    display_board
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if @current_player == human
    end
  end

  def set_markers
    human.choose_marker
    computer.marker = human.marker == 'X' ? 'O' : 'X'
  end

  def set_names
    human.choose_name
    computer.set_name
  end

  def pre_game_setup
    set_names
    set_markers
    choose_starting_player
  end

  def main_game
    pre_game_setup
    loop do
      play_round
      end_round
      break if game_won?
      break unless play_again?
      reset
      display_play_again_message
    end
    end_of_game
  end

  public

  def play
    clear
    display_welcome_message
    main_game
    display_goodbye_message
  end
end

game = TTTGame.new
game.play
