class Pieces
  attr_reader :pos, :color

  def initialize(pos, board, color=nil)
    @pos = pos
    @color = color
    @board = board
  end

  def moves
  end

  def pos=(pos)
    @pos = pos
    @board[pos] = self
  end

  def to_s
    "#{symbol}"
  end

  def move_into_check?(end_pos)
    @board[end_pos].is_a?(King)
  end
end
