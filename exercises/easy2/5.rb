class Something
  def initialize
    @data = 'Hello'
  end

  def dupdata
    @data + @data
  end

  def self.dupdata
    'ByeBye'
  end
end

thing = Something.new # creates a new Something object called thing
puts Something.dupdata # prints "ByeBye"
puts thing.dupdata # prints "HelloHello"