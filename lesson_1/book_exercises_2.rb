class Student
  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(student)
    self.grade > student.grade
  end

  protected

  def grade
    @grade
  end
end

joe = Student.new("Joe", 88)
bob = Student.new("Bob", 79)

puts "Well done!" if joe.better_grade_than?(bob)
