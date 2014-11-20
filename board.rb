require_relative 'piece'
require 'colorize'

class Board

#  attr_accessor :grid

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def pieces
    @grid.flatten.compact
  end

  def dup
    dup = Board.new(false)
    pieces.each do |piece|
      pos = piece.pos.dup
      dup[pos] = Piece.new(pos, piece.color, dup, piece.is_king?)
    end
    dup
  end

  def initialize(start = true)
    @grid = Array.new(8) { Array.new(8) }
    set_pieces if start
  end

  def set_pieces
    # These go over 80 chars but for the sake of readability they're one-liners
    @grid[0].map!.with_index { |s, i| Piece.new([0, i], :red, self) if i.odd? }
    @grid[1].map!.with_index { |s, i| Piece.new([1, i], :red, self) if i.even? }
    @grid[2].map!.with_index { |s, i| Piece.new([2, i], :red, self) if i.odd? }
    @grid[5].map!.with_index { |s, i| Piece.new([5, i], :black, self) if i.even?}
    @grid[6].map!.with_index { |s, i| Piece.new([6, i], :black, self) if i.odd?}
    @grid[7].map!.with_index { |s, i| Piece.new([7, i], :black, self) if i.even?}
  end

  def update(start_pos, end_pos)
    self[end_pos], self[start_pos] = self[start_pos], nil
  end

  def capture(pos)
    self[pos] = nil
  end

  def empty?(pos)
    self[pos].nil?
  end

  def render
    render = @grid.map.with_index do |row, i|
      row.map.with_index do |space, j|
        bg_color = (i.even? ^ j.even?) ? :green : :default
        piece = space ? space.render : " "
        piece.colorize(background: bg_color)
      end
         .join("")
    end
    puts render
  end

end
