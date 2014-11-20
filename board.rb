require_relative 'piece'

class Board

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def initialize(start = true)
    @grid = Array.new(8) { Array.new(8) }
    set_pieces if start
  end

  def set_pieces
    # These go over 80 chars but for the sake of readability they're one-liners
    @grid[0].map.with_index { |s, i| i.odd? ? Piece.new([0, i], :red, self) : nil }
    @grid[1].map.with_index { |s, i| i.even? ? Piece.new([1, i], :red, self) : nil }
    @grid[2].map.with_index { |s, i| i.odd? ? Piece.new([2, i], :red, self) : nil }
    @grid[5].map.with_index { |s, i| i.even? ? Piece.new([5, i], :black, self) : nil }
    @grid[6].map.with_index { |s, i| i.odd? ? Piece.new([6, i], :black, self) : nil }
    @grid[7].map.with_index { |s, i| i.even? ? Piece.new([7, i], :black, self) : nil }
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

end
