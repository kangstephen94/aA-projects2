class Rook < Pieces

  include SlidingPiece

  def move_dirs
    [[0,1],[1,0],[0,-1],[-1,0]]
  end

  def symbol
    :R
  end




end
