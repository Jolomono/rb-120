require 'pry'

class MinilangError < StandardError; end
class InvalidCommandError < MinilangError; end
class EmptyStackError < MinilangError; end


class Minilang

  attr_accessor :register
  attr_reader :stack, :command_list

  VALID_COMMANDS = %w(PUSH ADD SUB MULT DIV MOD POP PRINT)

  def initialize(command_string)
    @register = 0
    @command_list = command_string.split
    @stack = []
  end

  def interpret(string)
    if number?(string)
      number_to_register(string)
    else
      resolve(string)
    end
  end

  def resolve(command)
    unless VALID_COMMANDS.include?(command)
      raise InvalidCommandError, "Invalid Token: #{command}"
    end

    case command
    when "PUSH" then push
    when "ADD" then add
    when "SUB" then subtract
    when "MULT" then mult
    when "DIV" then div
    when "MOD" then mod
    when "POP" then stack_to_register
    when "PRINT" then print_register
    end
    # display_register_and_stack(command)
  end

  def display_register_and_stack(command)
    puts "Command: #{command}"
    puts "Register: #{register}"
    puts "Stack: #{stack}"
    puts ""
  end

  def number_to_register(number_string)
    self.register = number_string.to_i
  end

  def number?(string)
    string == string.to_i.to_s
  end

  def push
    stack << register
  end

  def add
    self.register += stack_pop
  end

  def subtract
    self.register -= stack_pop
  end

  def mult
    self.register *= stack_pop
  end

  def div
    self.register /= stack_pop
  end

  def mod
    self.register %= stack_pop
  end

  def stack_to_register
    self.register = stack_pop
  end

  def stack_pop
    if stack.empty?
     raise EmptyStackError, "Empty stack!"
    else
     stack.pop
    end
  end

  def print_register
    puts register
  end

  def eval
    command_list.each do |string|
      interpret(string)
    end

  rescue MinilangError => error
    puts error.message
  end

end


# Minilang.new('PRINT').eval
# # 0

# Minilang.new('5 PUSH 3 MULT PRINT').eval
# # 15

# Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# # 5
# # 3
# # 8

# Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# # 10
# # 5

# Minilang.new('5 PUSH POP POP PRINT').eval
# # Empty stack!

# Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# # 6

# Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# # 12

# Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# # Invalid token: XSUB

# Minilang.new('-3 PUSH 5 SUB PRINT').eval
# # 8

# Minilang.new('6 PUSH').eval
# # (nothing printed; no PRINT commands)