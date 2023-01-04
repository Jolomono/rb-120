require 'pry'

class Machine
  attr_writer :switch

  def start
    flip_switch(:on)
  end

  def stop
    flip_switch(:off)
  end

  private

  attr_writer :switch

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

test = Machine.new
test.start
p test
test.stop
p test