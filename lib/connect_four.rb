# frozen_string_literal: false

require_relative './game_board'

# Connect four game on terminal
class ConnectFour
  attr_reader :row_amount, :col_amount, :board, :player_round, :player1_piece, :player2_piece

  def initialize(row_amount = 6, col_amount = 7, board = GameBoard.new)
    @row_amount = row_amount
    @col_amount = col_amount
    @board = board
    @player_round = 'player1'
    @player1_piece = "\e[33m\u25cf\e[0m"
    @player2_piece = "\e[34m\u25cf\e[0m"
  end

  def main
    intro
    progress_round
    outro
  end

  def progress_round
    puts board.to_s

    loop do
      print_current_player

      input = player_input

      insert_to_board_col(input)
      puts board.to_s

      break if game_over?

      advance_round
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

  def game_over?
    return true if board.full?

    return true if board.four_same_piece_in_col?(player1_piece, player2_piece)

    return true if board.four_same_piece_in_row?(player1_piece, player2_piece)

    return true if board.four_same_piece_in_diagonal?(player1_piece, player2_piece)

    false
  end

  def advance_round
    @player_round = @player_round == 'player1' ? 'player2' : 'player1'
  end

  def insert_to_board_col(col_index)
    curr_piece = player_round == 'player1' ? player1_piece : player2_piece
    board.insert_piece_to_col(col_index, curr_piece)
  end

  def board_full?
    board.full?
  end

  def board_col_full?(col_index)
    board.col_full?(col_index)
  end

  def board_horizontal_game_over?
    board.four_same_piece_in_row?(player1_piece,player2_piece)
  end

  def board_vertical_game_over?
    board.four_same_piece_in_col?(player1_piece, player2_piece)
  end

  def board_diagonal_game_over?
    board.four_same_piece_in_diagonal?(player1_piece, player2_piece)
  end

  def intro
    puts <<~INTRO
      ----------------
      --Connect Four--
      ----------------
    INTRO
  end

  def print_board
    puts "\n"

    board.each do |row|
      puts "|#{row.join('|')}|"
    end

    puts " #{(0..6).to_a.join(' ')}"
  end

  def print_current_player
    puts "Current player: #{player_round == 'player1' ? 'player1' : 'player2'}"
  end

  def draw_game
    puts 'There is no winner'
  end

  def outro
    return draw_game if board.full?

    puts <<~OUTRO

      The winner is:
      ----------------
      ----#{winner}-----
      ----------------
    OUTRO
  end

  def winner
    player_round == 'player1' ? 'player1' : 'player2'
  end
end

# TODO
# Make the board prettier?

ConnectFour.new.main
