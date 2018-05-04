class Pawn
  require SteppingPiece

  def move_dir
    case @color
    when :black
      moves = [[1,0]]
    when :white
      moves = [[-1, 0]]
    end
    moves
  end

  #
  # private

  # def enemy_diagonal(pos)
  #   case @color
  #   when :black
  #     attack_positions = []
  #     attack_positions << [@board[pos][0] + 1, @board[pos][1] - 1]
  #     attack_positions << [@board[pos][0] + 1, @board[pos][1] + 1]
  #     attack_positions.select {|pos| @board[pos] }
  #
  # end
  #

  # end
end
