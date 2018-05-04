class Bishop < Pieces

  include SlidingPiece

  def move_dirs
    [[1,1],[-1,1],[1,-1],[-1,-1]]
  end

  def symbol
    :B
  end


end
