class InvalidMoveError < StandardError
  def message
    "invalid move, try another combination"
  end
end
