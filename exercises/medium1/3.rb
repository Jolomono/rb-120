class Student
  def initialize(name, year)
    @name = name
    @year = year
  end
end

class Graduate < Student
  def initialize(name, year, parking)
    super(name, year)
    @parking = parking
  end
end

class Undergraduate < Student

end

under = Undergraduate.new('joe', 1999)
grad = Graduate.new('dave', 2000, 'on campus')
p under
p grad