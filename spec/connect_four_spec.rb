# frozen_string_literal: false

require_relative './../lib/connect_four'

describe ConnectFour do
  subject(:game) { described_class.new }

  describe '#verify_input' do
    context 'when given the input' do
      it 'return the input if input is between columns index' do
        valid_input = 0
        result = game.verify_input(valid_input)

        expect(result).to eq(valid_input)
      end

      it 'return the input if input is first columns index' do
        first_col_index = 0
        valid_input = first_col_index
        result = game.verify_input(valid_input)

        expect(result).to eq(valid_input)
      end

      it 'return the input if input is last columns index' do
        last_col_index = 6
        valid_input = last_col_index
        result = game.verify_input(valid_input)

        expect(result).to eq(valid_input)
      end

      it 'return nil if input is out of bound' do
        invalid_input = 100
        result = game.verify_input(invalid_input)

        expect(result).to be_nil
      end
    end

    context 'if the column is already fulled' do
      let(:col_full_input) { 0 }

      before do
        allow(game).to receive(:board_col_full?).with((col_full_input)).and_return(true)
      end

      it 'return nil' do
        result = game.verify_input(col_full_input)

        expect(result).to be_nil
      end
    end
  end

  describe '#player_input' do
    let(:error_message) { 'Invalid input. Please try again.' }

    context 'when given a valid input' do
      it 'return the valid input num' do
        valid_input = '3'
        allow(game).to receive(:gets).and_return(valid_input)
        result = game.player_input
        expected_return_value = 3

        expect(result).to eq(expected_return_value)
      end

      it 'does not output exception' do
        valid_input = '3'
        allow(game).to receive(:gets).and_return(valid_input)

        expect(game).to_not receive(:puts).with(error_message)

        game.player_input
      end
    end

    context 'when given an invalid input then a valid input' do
      before do
        invalid_input = 'tuna'
        valid_input = '3'
        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
        allow(game).to receive(:puts)
      end

      it 'return valid input num at the end' do
        result = game.player_input
        expected_return_value = 3

        expect(result).to eq(expected_return_value)
      end

      it 'do output exception' do
        expect(game).to receive(:puts).with(error_message).once

        game.player_input
      end
    end

    context 'when given three invalid input, then one valid input' do
      before do
        invalid_input1 = 'potato'
        invalid_input2 = '###$$$!!!!'
        invalid_input3 = 'Today is a good day.'
        valid_input = '3'
        allow(game).to receive(:gets).and_return(invalid_input1, invalid_input2, invalid_input3, valid_input)
        allow(game).to receive(:puts)
      end

      it 'output exception three times' do
        expect(game).to receive(:puts).with(error_message).exactly(3).time

        game.player_input
      end

      it 'return valid input num at the end' do
        result = game.player_input
        expected_return_value = 3

        expect(result).to eq(expected_return_value)
      end
    end
  end

  describe '#advance_round' do
    context 'if current round is player1 round' do
      before do
        game.instance_variable_set(:@player_round, 'player1')
      end

      it 'next round is player2 round' do
        game.advance_round
        next_round = game.instance_variable_get(:@player_round)

        expect(next_round).to eq('player2')
      end
    end

    context 'if current round is player2 round' do
      before do
        game.instance_variable_set(:@player_round, 'player2')
      end

      it 'next round is player1 round' do
        game.advance_round
        next_round = game.instance_variable_get(:@player_round)

        expect(next_round).to eq('player1')
      end
    end
  end

  describe '#insert_to_board_col' do    let(:col_num) { 0 }
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

      xit 'return true' do
        result = game.board_diagonal_game_over?

        expect(result).to eq(true)
      end
    end

    context 'when same player does not line up 4 piece diagonally' do
      before do
        game.instance_variable_set(:@player_round, 'player1')
        allow(game).to receive(:player_input).and_return(0, 1, 2, 3)
      end

      xit 'return false' do
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

  describe 'game_over?' do
    context 'when the board is full' do
      before do
        allow(game).to receive(:board_full?).and_return true
      end

      it 'return true' do
        result = game.game_over?

        expect(result).to eq(true)
      end
    end

    context 'when the vertical winning condition is reached' do
      before do
        allow(game).to receive(:board_vertical_game_over?).and_return(true)
      end

      it 'return true' do
        result = game.game_over?

        expect(result).to eq(true)
      end
    end

    context 'when the horizontal winning condition is reached' do
      before do
        allow(game).to receive(:board_horizontal_game_over?).and_return(true)
      end

      it 'return true' do
        result = game.game_over?

        expect(result).to eq(true)
      end
    end

    context 'when the diagonal winning condition is reached' do
      before do
        allow(game).to receive(:board_diagonal_game_over?).and_return(true)
      end

      it 'return true' do
        result = game.game_over?

        expect(result).to eq(true)
      end
    end

    context 'when neither above 4 conditions is reached' do
      before do
        allow(game).to receive(:board_full?).and_return(false)
        allow(game).to receive(:board_vertical_game_over?).and_return(false)
        allow(game).to receive(:board_horizontal_game_over?).and_return(false)
        allow(game).to receive(:board_vertical_game_over?).and_return(false)
      end

      it 'return false' do
        result = game.game_over?

        expect(result).to eq(false)
      end
    end
  end
end

<<~NOTE
  Maybe I could isolate board into a new class..?

  Implement main method.
  Implement intro and outro method.
  Test winner method
NOTE

<<~TODO
  Implement legit diagonal check method
TODO
