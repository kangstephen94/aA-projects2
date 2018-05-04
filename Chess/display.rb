require 'colorize'
require_relative "cursor"

class Display

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end

  def render
    @board.grid.each_with_index do |row, idx1|
      row.each_with_index do |piece, idx2|
        sum = idx1 + idx2
        sum.even? ? color = :white : color = :black
        if [idx1, idx2] == @cursor.cursor_pos
          print "#{piece.value}".colorize(color: :red, background: color)
        else
          print "#{piece.value}".colorize(background: color)
        end
      end
      puts ''
    end
  end

end
