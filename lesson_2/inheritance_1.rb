module Swim
  def swim
    'swimming!'
  end
end

class Dog
  include Swim

  def speak
    'bark!'
  end


end

class Bulldog < Dog
  # def swim
  #   "can't swim!"
  # end
end

teddy = Dog.new
puts teddy.speak           # => "bark!"
puts teddy.swim           # => "swimming!"

roscoe = Bulldog.new
puts roscoe.swim

puts Bulldog.ancestors