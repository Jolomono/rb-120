module Offroadable
  def offroad
    "We're taking this baby offroad!"
  end
end

class Vehicle
  def initialize(year, model, color)
    @year = year
    @model = model
    @color = color
    @current_speed = 0
    @@number_of_vehicles += 1
  end

  @@number_of_vehicles = 0

  attr_accessor :color
  attr_reader :year, :model

  def self.number_of_vehicles
    puts "There are currently #{@@number_of_vehicles} vehicles created."
  end

  def self.gas_mileage(gallons, miles)
    puts "#{miles/gallons} miles per gallon of gas."
  end

  def speed_up(number)
    @current_speed += number
    puts "You push the gas and accelerate #{number} mph."
  end

  def brake(number)
    @current_speed -= number
    puts "You push the brake and decelerate #{number} mph."
  end

  def current_speed
    puts "You are now going #{@current_speed} mph."
  end

  def shut_down
    @current_speed = 0
    puts "Let's park this bad boy!"
  end

  def spray_paint(color)
    self.color = color
    puts "Your new #{color} paint job looks great!"
  end

  def age
    "Your #{self.model} is #{years_old} years old."
  end

  private

  def years_old
    require 'time'
    Time.now.year - self.year
  end

end

class MyCar < Vehicle
  NUMBER_OF_DOORS = 4

  def to_s
    "My car is a #{color} #{year} #{model} going #{@current_speed} mph."
  end
end

class MyTruck < Vehicle
  NUMBER_OF_DOORS = 2

  include Offroadable

  def to_s
    "My truck is a #{color} #{year} #{model} going #{@current_speed} mph."
  end
end



dynasty = MyCar.new(1992, "Dodge Dynasty", 'white')

ranger = MyTruck.new(2010, "Ford Tundra", 'red')

# puts "My car is #{dynasty.color}."
# dynasty.color = "red"
# puts "My car is #{dynasty.color}."
# puts "The year of my car is #{dynasty.year}."

# dynasty.spray_paint("blue")
# puts "My car is #{dynasty.color}."

MyCar.gas_mileage(13, 250)

puts dynasty
puts ranger

Vehicle.number_of_vehicles

# puts "MyCar Method Lookup Order:"
# puts MyCar.ancestors

# puts "MyTruck Method Lookup Order:"
# puts MyTruck.ancestors

puts dynasty.age



# dynasty.speed_up(20)
# dynasty.current_speed
# dynasty.speed_up(20)
# dynasty.current_speed
# dynasty.brake(20)
# dynasty.current_speed
# dynasty.brake(20)
# dynasty.current_speed
# dynasty.shut_down
# dynasty.current_speed
