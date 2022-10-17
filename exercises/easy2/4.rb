# Note that uppercase is an instance method meaning it needs an object of Class Transform to operate on while downcase is a Class Method of Transform that just needs an argument and the appropriate method call

class Transform
  attr_reader :text

  def initialize(text)
    @text = text
  end

  def uppercase
    text.upcase
  end

  def self.lowercase(text)
    text.downcase
  end
end

my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase("XYZ")