# frozen_string_literal: false

# Connect four game on terminal
class ConnectFour
  def initialize(row_amount = 6, col_amount = 7)
    @board = Array.new(row_amount) { Array.new(col_amount, '') }
    @col_insert_pos = Array.new(col_amount, row_amount - 1)
    @player_round = 'player1'
    @player1_piece = '0'
    @player2_piece = 'X'
  end

  def player_input
    loop do
      input = gets.chomp
      verified_num = verify_input(input.to_i) if input.match?(/^\d$/)

      return verified_num if verified_num

      puts 'Invalid input. Please try again.'
    end
  end

  def verify_input(input_num)
    input_num if input_num.between?(0, 6)
  end

  def advance_round
    @player_round = 
      if @player_round == 'player1'
        'player2'
      else
        'player1'
      end
  end

  def insert_to_board_col(col_index)
    insert_pos = @col_insert_pos[col_index]

    @board[col_index][insert_pos] =
      if @player_round == 'player1'
        @player1_piece
      else
        @player2_piece
      end
  end

  def board_col_full?(col_index)
    false
  end
end
