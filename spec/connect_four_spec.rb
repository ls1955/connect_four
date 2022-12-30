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

    before do
      allow(game).to receive(:player_prompt)
    end

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

  describe 'game_over?' do
    context 'when the board is full' do
      before do
        allow(game).to receive(:draw_game)
        allow(game).to receive(:board_full?).and_return(true)
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
