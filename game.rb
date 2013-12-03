require_relative 'board'
require_relative 'errors'

class Game
  attr_accessor :board, :winner
  def initialize
    @board = Board.new
    @winner = nil
  end

  def run
    initial_text
    over = false
    while !over?
      begin
        print "\n position: "
        position = gets.chomp.split(",")
        print "move: "
        move = gets.chomp.split(",")
        position = position.map {|pos| Integer(pos) }
        if board[position[0], position[1]].valid_move_seq?(*move)
          board[position[0],position[1]].perform_moves!(*move)
        end
      rescue InvalidMoveError, NoMethodError
        p "Invalid move, try another option"
        next
      ensure
        board.render
      end
    end
    p "#{ @winner.to_s.upcase } wins the game!"
  end

  def over?
    if board.grid.all? { |row| row.none? {|el| !el.nil? && el.color == :red } }
      @winner = :green
      true
    elsif
      board.grid.all? { |row| row.none? {|el| !el.nil? && el.color == :green } }
      @winner = :red
      true
    else
      false
    end
  end

  private

  def initial_text
    print "Enter position and -l for left, -r for right. \n
    If king, enter position and -dl for down left, \n
    -ul for up left, -ur for up right, or -dr for down right.\n
    For multiple jumps, separate arguments with commas: "
  end
end
