require_relative 'pieces'

class Queen < Pieces

  include SlidingPiece

  def move_dirs
    [[0,1],[1,0],[1,1],[0,-1],[-1,0],[-1,1],[1,-1],[-1,-1]]
  end

  def symbol
    :Q
  end




end
