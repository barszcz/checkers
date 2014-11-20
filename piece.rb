class Piece

  attr_reader :color, :pos

  def initialize(pos, color, board, king = false)
    @pos, @color, @board, @king = pos, color, board, king
  end

  def perform_move(new_pos)

    if jump_moves.include?(new_pos)
      perform_jump!(new_pos)
    elsif slide_moves.include?(new_pos)
      perform_slide!(new_pos)
    else
      return false
    end

    true

  end

  def king
    @king = true
  end

  def is_king?
    @king
  end

  def render
    c = is_king? ? "♚" : "●"
    @color == :red ? c.colorize(:red) : c
  end

  private

  def perform_slide!(new_pos)
    @board.update(@pos, new_pos)
    @pos = new_pos
  end

  def perform_jump!(new_pos)
    @board.update(@pos, new_pos)
    @board.capture(jumped_pos(new_pos))
    @pos = new_pos
  end

  def slide_moves
    get_moves(slide_diffs)
  end

  def jump_moves
    jump_moves = get_moves(jump_diffs)
    jump_moves.select! do |move|
      jumped_piece = @board[jumped_pos(move)]
      jumped_piece && jumped_piece.color != color
    end
    jump_moves
  end

  def jumped_pos(move)
    # lol
    [pos, move].transpose.map { |coords| coords.inject(:+) / 2 }
  end

  def get_moves(diffs)
    moves = diffs.map { |diff| [diff[0] + pos[0], diff[1] + pos[1]] }
    moves.select do |move|
      move.all? { |coord| coord.between?(0, 7) } &&
      @board.empty?(move)
    end
  end

  def slide_diffs
    red_slide_diffs = [
      [1, -1],
      [1, 1]
    ]

    black_slide_diffs = [
      [-1, -1],
      [-1, 1]
    ]

    if is_king?
      red_slide_diffs + black_slide_diffs
    else
      color == :red ? red_slide_diffs : black_slide_diffs
    end

  end

  def jump_diffs
    slide_diffs.map do |diff|
      diff.map { |coord| coord * 2 }
    end
  end

end
