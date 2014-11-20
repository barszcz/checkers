class Piece

  attr_reader :color

  def initialize(pos, color, board, king = false)
    @pos, @color, @board, @king = pos, color, board, king
  end

  def perform_slide
    diffs = slide_diffs
    moves = diffs.map do |diff|
      [diff[0] + pos[0], diff[1] + pos[1]]
    end
    moves.select! do |move|
      move.all? { |coord| coord.between?(0, 7) } &&
      board[move].nil?
    end
  end

  def perform_jump

  end

  def is_king?
    @king
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
    red_jump_diffs = [
      [2, -2],
      [2, 2]
    ]

    black_jump_diffs = [
      [-2, -2],
      [-2, 2]
    ]

    if is_king?
      red_jump_diffs + black_jump-diffs
    else
      color == :red ? red_slide_diffs : black_slide_diffs
    end
  end

end
