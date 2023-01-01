# frozen_string_literal: false

# ..the connect four gameboard
class GameBoard
  attr_reader :layout, :insert_row_pos, :row_amount, :col_amount

  def initialize(row_amount = 6, col_amount = 7)
    @row_amount = row_amount
    @col_amount = col_amount
    @layout = Array.new(row_amount) { Array.new(col_amount, ' ') }
    @insert_row_pos = Array.new(col_amount, row_amount - 1)
  end

  def insert_piece_to_col(col, piece)
    layout[insert_row_pos[col]][col] = piece
    update_insert_row_pos(col)
  end

  def update_insert_row_pos(col)
    insert_row_pos[col] -= 1
  end

  def four_same_piece_in_row?(piece1, piece2)
    window_size = 4

    layout.each do |row|
      window = []

      row.each do |col|
        window << col

        next unless window.length == window_size

        return true if window.all?(piece1) || window.all?(piece2)

        window.shift
      end
    end

    false
  end

  def four_same_piece_in_col?(piece1, piece2)
    window_size = 4

    col_amount.times do |col|
      window = []
      row_amount.times do |row|
        window << layout[row][col]

        next unless window.length == window_size

        return true if window.all?(piece1) || window.all?(piece2)

        window.shift
      end
    end

    false
  end

  def four_same_piece_in_diagonal?(piece1, piece2)
    0.upto(3) do |col|
      0.upto(2) do |row|
        diagonal = []

        4.times { |offset| diagonal << layout[row + offset][col + offset] }

        return true if diagonal.all?(piece1) || diagonal.all?(piece2)
      end
    end

    6.downto(3) do |col|
      0.upto(2) do |row|
        diagonal = []

        4.times { |offset| diagonal << layout[row + offset][col - offset] }

        return true if diagonal.all?(piece1) || diagonal.all?(piece2)
      end
    end

    false
  end

  def full?
    layout.each { |row| return false if row.any?(' ') }
    true
  end

  def game_over?(p1_piece, p2_piece)
    full? || four_same_piece_in_col?(p1_piece, p2_piece) || four_same_piece_in_row?(p1_piece, p2_piece) || four_same_piece_in_diagonal?(p1_piece, p2_piece)
  end

  def col_full?(col)
    row_amount.times { |row| return false if layout[row][col] == ' ' }
    true
  end

  # FIXME
  # print class and encoding of ID although overrode ethod
  def to_s
    puts "\n"
    layout.each { |row| puts "|#{row.join('|')}|" }
    puts " #{(0..6).to_a.join(' ')}"
  end
end
