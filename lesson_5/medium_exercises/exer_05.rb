class StackError < StandardError; end

class InvalidTokenError < StandardError; end

class Minilang
  def initialize(commands)
    @stack = Array.new
    @register = 0
    @commands = commands.split(' ')
  end

  def eval
    commands.each do |command|
      if !number?(command)
        begin
          raise_invalid_token_error(command) unless command_exists?(command)
          self.send (command.downcase)
        rescue => e
          puts e.message
          return
        end
      else
        self.send :n, command
      end
    end
  end

  private

  attr_reader :stack, :register, :commands

  def print
    puts register
  end

  def number?(string)
    string.to_i.to_s == string
  end

  def n(number)
    @register = number.to_i
  end

  def push
    stack << register
  end

  def mult
    raise_stack_error if stack.empty?
    multiplier = stack.pop
    @register = register * multiplier
  end

  def add
    raise_stack_error if stack.empty?
    summand = stack.pop
    @register = register + summand
  end

  def sub
    raise_stack_error if stack.empty?
    term = stack.pop
    @register = register - term
  end

  def pop
    raise_stack_error if stack.empty?
    @register = stack.pop
  end

  def div
    raise_stack_error if stack.empty?
    divisor = stack.pop
    @register = register / divisor
  end

  def mod
    raise_stack_error if stack.empty?
    divisor = stack.pop
    @register = register % divisor
  end

  def raise_stack_error
    raise StackError, "Stack is empty!"
  end

  def raise_invalid_token_error(command)
    raise InvalidTokenError, "Invalid Token: #{command}"
  end

  def command_exists?(command)
    self.class.private_method_defined?(command.downcase, false)
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# # 10
# # 5

Minilang.new('5 PUSH POP POP PRINT').eval
# # Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# # 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# # 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# # Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# # 8

Minilang.new('6 PUSH').eval
# # (nothing printed; no PRINT commands)