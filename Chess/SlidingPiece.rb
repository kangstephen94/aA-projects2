module SlidingPiece

  def moves
    moves = []

    move_dir.each do |dir|
      end_pos = [@pos[0] + dir[0], @pos[1] + dir[1]]

      until !@board.valid_pos?(end_pos)
        moves << end_pos
        end_pos = [end_pos[0] + dir[0], end_pos[1] + dir[1]]
      end
    end

    moves 
  end

  private
  def move_dir
  end

  def attackable?(end_pos)
    @board[start_pos].color

  end
end
