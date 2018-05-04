require_relative 'pieces'
require 'singleton'

class NullPieces < Pieces
  include Singleton

  def symbol
  end
  
end
