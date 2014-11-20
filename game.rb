class InvalidMoveError < StandardError
end

require_relative 'board'

class CheckersGame

  def initialize(game_board = Board.new)
    @game_board = game_board
  end

  def play
    puts "Welcome to Checkers!"

    until lost?(:red) || lost?(:black)
      @game_board.render
      play_turn(:red)
      @game_board.render
      play_turn(:black)
    end

    if lost?(:red)
      puts "Black wins!"
    else
      puts "Red wins!"
    end

  end

  private

  def play_turn(color)

    begin
      puts "#{color.to_s.capitalize}: Enter a move or move sequence."
      input = gets.chomp

      moves_arr = parse_moves(input)
      piece_to_move = @game_board[moves_arr.shift]

      if piece_to_move.nil?
        raise InvalidMoveError.new "There's no piece there."
      elsif piece_to_move.color != color
        raise InvalidMoveError.new "Move your own damn piece."
      end

      piece_to_move.perform_moves(*moves_arr)

    rescue InvalidMoveError => e
      puts e
      retry
    end

    promote_kings(color)


  end

  def promote_kings(color)
    king_row = color == :red ? 7 : 0
    @game_board.pieces(color).select do |piece|
      piece.pos.first == king_row
    end.each(&:king_me)
  end

  def lost?(color)
    @game_board.pieces(color).empty?
  end


  def parse_moves(input)

    columns = %w(A B C D E F G H)

    moves_arr = input.split(" ")

    unless moves_arr.all? { |move_str| move_str =~ /\A[A-H][1-8]\z/i } && moves_arr.length > 1
      raise InvalidMoveError.new "That isn't a move sequence!"
    end

    moves_arr.map! do |move_str|
      col_str, row_str = move_str.split("")
      row = row_str.to_i - 1
      col = columns.index(col_str.upcase)
      [row,col]
    end
    moves_arr
  end

end
