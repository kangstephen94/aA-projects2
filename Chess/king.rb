class King < Pieces

  include SteppingPiece

  def move_dirs
    [[0,1],[1,0],[1,1],[0,-1],[-1,0],[-1,1],[1,-1],[-1,-1]]
  end

  def symbol
    :K
  end



end
