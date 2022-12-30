# frozen_string_literal: false

require_relative './../lib/game_board'

describe GameBoard do
  subject(:game_board) { described_class.new }
  let(:player1_piece) { 'X' }
  let(:player2_piece) { 'O' }

  describe '#insert_piece_to_col' do
    let(:col) { 0 }
    let(:player_piece) { 'X' }
    let(:last_row) { game_board.row_amount - 1 }

    context 'when a column index and player piece is given' do
      it 'insert player piece into respective column' do
        game_board.insert_piece_to_col(col, player_piece)

        inserted_position = game_board.layout[last_row][col]

        expect(inserted_position).to eq(player_piece)
      end
    end
  end

  describe '#four_same_piece_in_row?' do
    context 'when 4 same pieces next to each other in a row' do
      board_layout = [
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', 'O', 'O', 'O', 'O']
      ]

      it 'return true' do
        game_board.instance_variable_set(:@layout, board_layout)
        result = game_board.four_same_piece_in_row?(player1_piece, player2_piece)
        expect(result).to eq(true)
      end
    end

    context 'when no 4 same pieces next to each other in a row' do
      board_layout = [
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        ['X', ' ', 'O', 'X', 'X', 'O', 'O']
      ]

      it 'return false' do
        game_board.instance_variable_set(:@layout, board_layout)
        result = game_board.four_same_piece_in_row?(player1_piece, player2_piece)
        expect(result).to eq(false)
      end
    end
  end

  describe '#four_same_piece_in_col?' do
    context 'when 4 same pieces next to each other in a column' do
      board_layout = [
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        ['X', ' ', ' ', ' ', ' ', ' ', ' '],
        ['X', ' ', ' ', ' ', ' ', ' ', ' '],
        ['X', ' ', ' ', ' ', ' ', ' ', ' '],
        ['X', ' ', ' ', ' ', ' ', ' ', ' '],
      ]

      it 'return true' do
        game_board.instance_variable_set(:@layout, board_layout)
        result = game_board.four_same_piece_in_col?(player1_piece, player2_piece)
        expect(result).to eq(true)
      end
    end

    context 'when no 4 same pieces next to each other in a column' do
      board_layout = [
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        ['X', ' ', ' ', ' ', ' ', ' ', ' '],
        ['O', ' ', ' ', ' ', ' ', ' ', ' '],
        ['O', ' ', ' ', ' ', ' ', ' ', ' '],
        ['X', ' ', ' ', ' ', ' ', ' ', ' ']
      ]

      it 'return false' do
        game_board.instance_variable_set(:@layout, board_layout)
        result = game_board.four_same_piece_in_col?(player1_piece, player2_piece)
        expect(result).to eq(false)
      end
    end
  end

  describe '#four_same_piece_in_diagonal?' do
    context 'when 4 same pieces next to each other in a diagonal' do
      board_layout = [
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', 'X', ' ', ' ', ' '],
        [' ', ' ', 'X', 'O', ' ', ' ', ' '],
        [' ', 'X', 'O', 'O', ' ', ' ', ' '],
        ['X', 'O', 'O', 'O', ' ', ' ', ' ']
      ]

      it 'return true' do
        game_board.instance_variable_set(:@layout, board_layout)
        result = game_board.four_same_piece_in_diagonal?(player1_piece, player2_piece)

        expect(result).to eq(true)
      end
    end

    context 'when no 4 same pieces next to each other in a diagonal' do
      board_layout = [
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', 'X', ' ', ' ', ' ', ' ', ' '],
        ['X', 'O', 'O', ' ', ' ', ' ', ' ']
      ]

      it 'return false' do
        game_board.instance_variable_set(:@layout, board_layout)
        result = game_board.four_same_piece_in_diagonal?(player1_piece, player2_piece)

        expect(result).to eq(false)
      end
    end
  end

  describe '#board_full?' do
    context 'when the board is not full' do
      board_layout = [
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', 'X', ' ', ' ', ' ', ' ', ' '],
        ['X', 'O', 'O', ' ', ' ', ' ', ' ']
      ]

      it 'return false' do
        game_board.instance_variable_set(:@layout, board_layout)
        result = game_board.full?

        expect(result).to eq(false)
      end
    end

    context 'when the board is full' do
      board_layout = [
        %w[X X X O O O X],
        %w[X 0 X O O O O],
        %w[0 X X O X X X],
        %w[X 0 X O O O X],
        %w[0 X X O X X O],
        %w[X 0 X O O O X],
        %w[X X 0 X O O X]
      ]

      it 'return true' do
        game_board.instance_variable_set(:@layout, board_layout)
        result = game_board.full?

        expect(result).to eq(true)
      end
    end
  end
end
