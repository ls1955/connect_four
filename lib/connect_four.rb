# frozen_string_literal: false

# Connect four game on terminal
class ConnectFour
  attr_reader :row_amount, :col_amount, :board, :player_round, :player1_piece, :player2_piece

  def initialize(row_amount = 6, col_amount = 7)
    @row_amount = row_amount
    @col_amount = col_amount
    @board = Array.new(row_amount) { Array.new(col_amount, ' ') }
    @col_insert_pos = Array.new(col_amount, row_amount - 1)
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
    print_board

    until game_over?
      print_current_player

      input = player_input

      insert_to_board_col(input)
      print_board

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
    input_num if input_num.between?(0, 6) && !board_col_full?(input_num)
  end

  def game_over?
    if board_full?
      draw_game
    elsif board_horizontal_game_over? || board_vertical_game_over? || board_diagonal_game_over?
      true
    else
      false
    end
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

    update_insert_pos(col_index)

    @board[insert_pos][col_index] =
      if @player_round == 'player1'
        @player1_piece
      else
        @player2_piece
      end
  end

  def update_insert_pos(col_index)
    @col_insert_pos[col_index] -= 1
  end

  def board_full?
    @col_amount.times do |col_index|
      return false unless board_col_full?(col_index)
    end

    true
  end

  def board_col_full?(col_index)
    @col_insert_pos[col_index] == -1
  end

  def board_horizontal_game_over?
    window_size = 4

    board.each do |row|
      (row.length - window_size).times do |left|
        curr_window = row[left..(left + (window_size - 1))]

        return true if curr_window.all?(player1_piece) || curr_window.all?(player2_piece)
      end
    end

    false
  end

  def board_vertical_game_over?
    @col_amount.times do |col_num|
      3.times do |row_start_index|
        curr_vertical_col = []

        4.times do |i|
          curr_vertical_col << @board[row_start_index + i][col_num]
        end

        return true if curr_vertical_col.all?(player1_piece) || curr_vertical_col.all?(player2_piece)
      end
    end

    false
  end

  def board_diagonal_game_over?
    0.upto(3) do |x|
      0.upto(2) do |y|
        return true if board[y][x] != ' ' && board[y][x] == board[y + 1][x + 1] && board[y][x] == board[y + 2][x + 2] && board[y][x] == board[y + 3][x + 3]
      end
    end

    6.downto(3) do |x|
      0.upto(2) do |y|
        return true if board[y][x] != ' ' && board[y][x] == board[y + 1][x - 1] && board[y][x] == board[y + 2][x - 2] && board[y][x] == board[y + 3][x - 3]
      end
    end

    false
  end

  def intro
    puts <<~INTRO
      ----------------
      --Connect Four--
      ----------------
    INTRO
  end

  def print_board
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
# REFACTOR class
# Allow player to choose their own piece?
