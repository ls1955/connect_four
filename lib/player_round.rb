# frozen_string_literal: false

# player round in game
class PlayerRound
  attr_accessor :player

  def initialize
    @player = 'player1'
  end

  def advance
    @player = player == 'player1' ? 'player2' : 'player1'
  end

  def to_s
    "Current player: #{player}"
  end
end
