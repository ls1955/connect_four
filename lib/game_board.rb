# frozen_string_literal: false

# ..the gameboard
class GameBoard
  attr_reader :board, :insert_row_pos, row_amount, col_amount

  def initialize(row_amount, col_amount)
    @row_amount = row_amount
    @col_amount = col_amount
    @board = Array.new(row_amount) { Array.new(col_amount, ' ') }
    @insert_row_pos = Array.new(col_amount, row_amount - 1)
  end

  def insert_piece_to_col(col, piece)
    board[insert_row_pos[col]][col] = piece
    update_insert_row_pos(col)
  end

  def update_insert_row_pos(col)
    insert_row_pos[col] -= 1
  end

  def print_board
    puts "\n"

    board.each do |row|
      puts "|#{row.join('|')}|"
    end

    puts " #{(0..6).to_a.join(' ')}"
  end
end
