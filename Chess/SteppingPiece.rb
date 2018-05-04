module SteppingPiece

  def moves
    move_dir.select do |dir|
      end_pos = [@pos[0] + dir[0], @pos[1] + dir[1]]
      valid_pos?(end_pos)
    end
  end


  private
  def move_dir
  end


end
