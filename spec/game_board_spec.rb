# frozen_string_literal: false

require_relative './../lib/game_board'

describe GameBoard do
  describe '#insert_to_board_col' do
    let(:col_num) { 0 }
    let(:p1_piece) { game.instance_variable_get(:@player1_piece) }
    let(:p2_piece) { game.instance_variable_get(:@player2_piece) }

    before do
      allow(game).to receive(:player_input).and_return(col_num)
    end

    context 'when current player is player1' do
      it 'insert player1 piece into column' do
        insert_pos = game.instance_variable_get(:@col_insert_pos)[col_num]
        game.insert_to_board_col(col_num)
        board_pos = game.instance_variable_get(:@board)[insert_pos][col_num]

        expect(board_pos).to eq(p1_piece)
      end
    end

    context 'when current player is player2' do
      before do
        game.instance_variable_set(:@player_round, 'player2')
      end

      it 'insert player2 piece into column' do
        insert_pos = game.instance_variable_get(:@col_insert_pos)[col_num]
        game.insert_to_board_col(col_num)
        board_pos = game.instance_variable_get(:@board)[insert_pos][col_num]

        expect(board_pos).to eq(p2_piece)
      end
    end

    context 'after player inserted piece' do
      it 'insert next piece at upper position of same column' do
        prev_insert_pos = game.instance_variable_get(:@col_insert_pos)[col_num]

        game.insert_to_board_col(col_num)

        new_insert_pos = game.instance_variable_get(:@col_insert_pos)[col_num]
        expected_next_pos = prev_insert_pos - 1

        expect(new_insert_pos).to eq(expected_next_pos)
      end
    end
  end

  describe '#board_horizontal_game_over?' do
    context 'when same player do not insert 4 pieces next to each other' do
      before do
        game.instance_variable_set(:@player_round, 'player1')
        allow(game).to receive(:player_input).and_return(0, 2, 4, 6)
      end

      it 'return false' do
        4.times do
          inputs = game.player_input
          game.insert_to_board_col(inputs)
        end

        result = game.board_horizontal_game_over?

        expect(result).to eq(false)
      end
    end

    context 'when same player insert 4 pieces next to each other' do
      before do
        game.instance_variable_set(:@player_round, 'player1')
        allow(game).to receive(:player_input).and_return(0, 1, 2, 3)
      end

      it 'return true' do
        4.times do
          inputs = game.player_input
          game.insert_to_board_col(inputs)
        end

        result = game.board_horizontal_game_over?

        expect(result).to eq(true)
      end
    end
  end

  describe '#board_vertical_game_over?' do
    context 'when same player put pieces in same column 4 times' do
      before do
        game.instance_variable_set(:@player_round, 'player1')
        allow(game).to receive(:player_input).and_return(0)
      end

      it 'return true' do
        4.times do
          inputs = game.player_input
          game.insert_to_board_col(inputs)
        end

        result = game.board_vertical_game_over?

        expect(result).to eq(true)
      end
    end

    context 'when same player put pieces in different column 4 times' do
      before do
        game.instance_variable_set(:@player_round, 'player1')
        allow(game).to receive(:player_input).and_return(0, 1, 2, 3)
      end

      it 'return false' do
        4.times do
          inputs = game.player_input
          game.insert_to_board_col(inputs)
        end

        result = game.board_vertical_game_over?

        expect(result).to eq(false)
      end
    end
  end

  describe '#board_diagonal_game_over?' do
    context 'when same player line up 4 piece diagonally' do
      before do
        game.instance_variable_set(:@player_round, 'player1')
        allow(game).to receive(:player_input).and_return(0, 1, 1, 2, 2, 2, 3)
      end

      it 'return true' do
        10.times do
          inputs = game.player_input
          game.insert_to_board_col(inputs)
        end

        result = game.board_diagonal_game_over?

        expect(result).to eq(true)
      end
    end

    context 'when same player does not line up 4 piece diagonally' do
      before do
        game.instance_variable_set(:@player_round, 'player1')
        allow(game).to receive(:player_input).and_return(0, 1, 2, 3)
      end

      it 'return false' do
        10.times do
          inputs = game.player_input
          game.insert_to_board_col(inputs)
        end

        result = game.board_diagonal_game_over?

        expect(result).to eq(false)
      end
    end
  end

  describe '#board_full?' do
    context 'when the board is not full' do
      it 'return false' do
        result = game.board_full?

        expect(result).to eq(false)
      end
    end

    context 'when the board is full' do
      before do
        allow(game).to receive(:board_col_full?).and_return(true)
      end

      it 'return true' do
        result = game.board_full?

        expect(result).to eq(true)
      end
    end
  end

  describe '#board_col_full?' do
    context 'when started a new game' do
      it 'first column is not full' do
        col_index = 0
        result = game.board_col_full?(col_index)

        expect(result).to be false
      end
    end

    context 'when the game is running' do
      let(:col_index) { 0 }
      let(:board_vertical_length) { 6 }

      before do
        player_input = col_index.to_s

        allow(game).to receive(:player_input).and_return(player_input)
      end

      it 'first column is not full after inserted number once' do
        game.player_input
        result = game.board_col_full?(col_index)

        expect(result).to be false
      end

      it 'first column is full if all slots had been inserted number' do
        board_vertical_length.times { game.insert_to_board_col(0) }
        result = game.board_col_full?(col_index)

        expect(result).to be true
      end
    end
  end
end
