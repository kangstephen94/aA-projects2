require_relative 'pieces'
require_relative 'nullpieces'

class Board

  attr_reader :grid

  def initialize
    @null_piece = NullPieces.instance
    @grid = Array.new(8) {Array.new(8, @null_piece)}
    setup_board
  end

  def valid_pos?(end_pos)
    !self[end_pos].nil? && self[end_pos] == NullPieces.instance
  end


  def move_piece(start_pos, end_pos)
    unless self[start_pos].is_a?(NullPieces) || self[end_pos].nil?
      self[end_pos] = self[start_pos]
      self[start_pos] = @null_piece
      self[end_pos].pos = end_pos
    end
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  private

  def setup_board
    @grid[0] = Array.new(8) {Pieces.new}
    @grid[1] = Array.new(8) {Pieces.new}
    @grid[6] = Array.new(8) {Pieces.new}
    @grid[7] = Array.new(8) {Pieces.new}
  end

end
