# coding: utf-8
require 'colorize'
require_relative 'board'
require_relative 'errors'

class Piece
  attr_accessor :king, :position, :board
  attr_reader :color
  def initialize(color, board, position, king = false)
    @color = color
    @board = board
    @position = position
    @king = king
  end

  def move_diffs
    if !king
      if color == :green
        diffs = green_diffs = [[1,1],[1,-1]]
      else
        diffs = red_diffs = [[-1,1],[-1,-1]]
      end
    else
      diffs = [[1,1],[1,-1],[-1,1],[-1,-1]]
    end
    diffs
  end

  def perform_jump(direction)
    delt = get_delt(direction)
    original_position = position
    cand_position = [position[0] + delt[0] + delt[0], position[1] + delt[1] + delt[1]]
    if valid_jump?(cand_position[0], cand_position[1], delt)
      switch_out_pos([position[0] + delt[0], position[1] + delt[1]], delt)
      self.position = cand_position
      clear_position(original_position)
    end
  end

  def perform_slide(direction)
    delt = get_delt(direction)
    if board.valid_destination?(position[0] + delt[0], position[1] + delt[1])
      switch_out_pos(position, delt)
    end
  end

  def perform_moves!(*args)
    delts = args.map { |direction| get_delt(direction) }
    if args.count == 1 && board.valid_destination?(position[0] +
      delts[0][0], position[1] + delts[0][1])
      perform_slide(*args)
      true
    else
      args.each_with_index do |move, idx|
        if valid_jump?(position[0] + delts[idx][0] + delts[idx][0],
          position[1] + delts[idx][1] + delts[idx][1], delts[idx])
          perform_jump(move)
        else
          raise InvalidMoveError
        end
      end
      true
    end
  end

  def valid_move_seq?(*args)
    p args
    duped_board = self.board.dup
    duped_piece = self.dup
    duped_board.grid = self.board.full_dup
    duped_piece.board = duped_board
    if duped_piece.perform_moves!(args)
      return true
    else
      false
    end
  end

  def maybe_promote
    if color == :green && position[0] == 7
      self.king = true
    elsif color == :red && position[0] == 0
      self.king = true
    end
  end

  def to_s
    color == :green ? " ◉ ".green : " ◉ ".red
  end

  def get_delt(direction)
    #case
    delt = nil
    if !king
      if direction.include?("-r")
        delt = move_diffs.first
      elsif direction.include?("-l")
        delt = move_diffs.last
      else
        raise InvalidMoveError
        return
      end
    elsif king
      if direction.include?("-ur")
        delt = move_diffs[2]
      elsif direction.include?("-dr")
        delt = move_diffs[0]
      elsif direction.include?("-ul")
        delt = move_diffs[3]
      elsif direction.include?("-dl")
        delt = move_diffs[1]
      else
        raise InvalidMoveError
        return
      end
    end
    delt
  end

  def clear_position(position)
    board[position[0], position[1]] = nil
  end

  def switch_out_pos(position, delt)
    new_position = [position.first + delt.first, position.last + delt.last]
    board[new_position[0], new_position[1]] = self
    self.position = new_position
    board[position[0], position[1]] = nil
    maybe_promote
  end

  def valid_jump?(row, col, delt)
    board[row, col] == nil &&
    !board[row - delt[0], col - delt[1]].nil? &&
    board[row - delt[0], col - delt[1]].color != color
  end
end
