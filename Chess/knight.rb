class Knight < Pieces

  include SteppingPiece

  def move_dirs
    [[2,1],[1,2],[-2,1],[2,-1],[-2,-1],[-1,2],[1,-2],[-1,-2]]
  end

  def symbol
    :H
  end




end
