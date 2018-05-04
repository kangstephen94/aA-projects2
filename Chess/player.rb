require_relative 'board'
require_relative 'cursor'

class Player

  def initialize(name, display)
    @name = name
    @display = display
    @cursor = Cursor.new([0,0], display)
  end




end
