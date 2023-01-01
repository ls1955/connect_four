# frozen_string_literal: false

require_relative './game_board'
require_relative './player_round'

# Connect four game on terminal
class ConnectFour
  attr_reader :row_amount, :col_amount, :board, :round, :player1_piece, :player2_piece

  def initialize(row_amount = 6, col_amount = 7, board = GameBoard.new, round = PlayerRound.new)
    @row_amount = row_amount
    @col_amount = col_amount
    @board = board
    @round = round
    @player1_piece = "\e[33m\u25cf\e[0m"
    @player2_piece = "\e[34m\u25cf\e[0m"
  end

  def main
    intro
    progress_round
    outro
  end

  def progress_round
    puts board

    loop do
      puts round

      input = player_input

      insert_to_board_col(input)

      puts board

      break if board.game_over?(player1_piece, player2_piece)

      round.advance
    end
  end

  def player_input
    loop do
      player_prompt
      input = gets.chomp
      verified_num = verify_input(input.to_i) if input.match?(/^\d$/)

      return verified_num if verified_num

      puts 'Invalid input. Please try again.'
    end
  end

  def player_prompt
    puts 'Please select a column.'
  end

  def verify_input(input_num)
    input_num if input_num.between?(0, 6) && !board.col_full?(input_num)
  end

  def curr_piece
    round.player == 'player1' ? player1_piece : player2_piece
  end

  def insert_to_board_col(col_index)
    board.insert_piece_to_col(col_index, curr_piece)
  end

  def intro
    puts <<~INTRO
      ----------------
      --Connect Four--
      ----------------
    INTRO
  end

  def outro
    if board.full?
      puts 'There is no winner'
    else
      puts <<~OUTRO

        The winner is:
        ----------------
        ----#{round.player}-----
        ----------------

      OUTRO
    end
  end
end
