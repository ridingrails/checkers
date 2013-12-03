require_relative 'piece'

class Board
  attr_accessor :grid
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    make_layout
  end

  def [](row_idx,col_idx)
    grid[row_idx][col_idx]
  end

  def []=(row_idx, col_idx, mark)
    grid[row_idx][col_idx] = mark
  end

  def full_dup
    duped_grid = grid.map do |row|
      row.dup
    end
    duped_grid
  end

  def valid_destination?(row, col)
    self[row, col] == nil && row.between?(0,7) && col.between?(0,7)
  end

  def to_s
    render
  end

  def make_layout
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |col, col_idx|
        grid[row_idx][col_idx] =
        if row_idx.between?(0,2) && !(row_idx + col_idx).even?
          Piece.new(:green, self, [row_idx, col_idx])
        elsif row_idx.between?(5,7) && !(row_idx + col_idx).even?
          Piece.new(:red, self, [row_idx, col_idx])
        else
          nil
        end
      end
    end
  end

  def render
    temp_board = ""
    grid.count.times do |row|
      temp_board += "\n"
      grid.count.times do |col|
        background = (row + col).even? ? :on_white : :on_black
        if self[row, col]
          temp_board += self[row, col].to_s.send(background)
        else
          temp_board += "   ".send(background)
        end
      end
    end
    puts temp_board
  end
end
