require 'pry'

class IndexError < StandardError ; end

class FixedArray
  attr_reader :contents

  def initialize(size)
    @contents = Array.new(size)
  end

  def [](index)
    raise IndexError unless valid_index?(index)
    contents[index]
  end

  def []=(index, value)
    raise IndexError unless valid_index?(index)
    contents[index] = value
  end

  def valid_index?(index)
    index = index * -1 if index < 0
    index < contents.size
  end

  def to_a
    contents.clone
  end

  def to_s
    contents.to_a.to_s
    # string = "["
    # contents.each_with_index do |element, idx|
    #   if element
    #     string << "\"#{element}\""
    #   else
    #     string << 'nil'
    #   end

    #   string << ", " unless idx == contents.size - 1
    # end
    # string << "]"
  end

end


fixed_array = FixedArray.new(5)
puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[-7] = 3
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[7] = 3
  puts false
rescue IndexError
  puts true
end