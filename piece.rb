class Piece

  attr_reader :color, :pos

  def initialize(pos, color, board, king = false)
    @pos, @color, @board, @king = pos, color, board, king
  end

  def perform_move(new_pos)
    slide_moves = get_moves(slide_diffs)
    jump_moves = get_moves(jump_diffs)

    #reassignment so I don't screw with the indexes
    jump_moves = jump_moves.select.with_index do |move, i|
      jumped_piece = @board[slide_moves[i]]
      jumped_piece && jumped_piece.color != color
    end

    if jump_moves.include?(new_pos) && @board.empty?(new_pos)
      perform_jump!(new_pos)

    elsif slide_moves.include?(new_pos) && @board.empty?(new_pos)
      perform_slide!(new_pos)

    else
      return false
    end

    true

  end

  def perform_slide!(new_pos)
    @board.update(@pos, new_pos)
    @pos = new_pos
  end

  def perform_jump!(new_pos)
    #kind of a crappy hack
    jumped_pos = [pos, new_pos].transpose.map { |coords| coords.inject(:+) / 2 }

    @board.update(@pos, new_pos)
    @board.capture(jumped_pos)
    @pos = new_pos
  end

  # def perform_slide(new_pos)
  #   diffs = slide_diffs
  #
  #   moves = diffs.map do |diff|
  #     [diff[0] + pos[0], diff[1] + pos[1]]
  #   end
  #
  #   moves.select! do |move|
  #     move.all? { |coord| coord.between?(0, 7) } &&
  #     board[move].nil?
  #   end
  #
  #   return false unless moves.include?(new_pos)
  #
  #   @board.update(@pos, new_pos)
  #   @pos = new_pos
  #   true
  # end
  #
  # def perform_jump
  #   diffs = jump_diffs
  #
  #   moves = diffs.map do |diff|
  #     [diff[0] + pos[0], diff[1] + pos[1]]
  #   end
  #
  #   moves.select! do |move|
  #     move.all? { |coord| coord.between?(0, 7) } &&
  #     board[move].nil?
  #   end
  #
  #   return false unless moves.include?(new_pos)
  #
  #   @board.update(@pos, new_pos)
  #   @pos = new_pos
  #
  # end


  def is_king?
    @king
  end

  def render
    if is_king?
      @color == :red ? "R" : "B"
    else
      @color == :red ? "r" : "b"
    end
  end

  private

  def get_moves(diffs)
    moves = diffs.map { |diff| [diff[0] + pos[0], diff[1] + pos[1]] }
    moves.select do |move|
      move.all? { |coord| coord.between?(0, 7) } # &&
      #board[move].nil?
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
  #   red_jump_diffs = [
  #     [2, -2],
  #     [2, 2]
  #   ]
  #
  #   black_jump_diffs = [
  #     [-2, -2],
  #     [-2, 2]
  #   ]
  #
  #   if is_king?
  #     red_jump_diffs + black_jump-diffs
  #   else
  #     color == :red ? red_slide_diffs : black_slide_diffs
  #   end
   end

end
