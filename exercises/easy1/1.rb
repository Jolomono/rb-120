class Banner
  def initialize(message)
    @message = message
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    message_length = @message.size
    result = "+-"
    message_length.times {result << "-"}
    result << "-+"
    result
  end

  def empty_line
    message_length = @message.size
    result = "| "
    message_length.times {result << " "}
    result << " |"
    result
  end

  def message_line
    "| #{@message} |"
  end
end

banner = Banner.new('To boldly go where no one has gone before.')
puts banner
