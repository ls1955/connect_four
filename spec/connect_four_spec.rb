# frozen_string_literal: false

require_relative './../lib/connect_four'

describe ConnectFour do
  describe '#verify_input' do
    subject(:game_given_input) { described_class.new }

    context 'when given the input' do
      it 'return the input if input is between columns index' do
        valid_input = 0
        result = game_given_input.verify_input(valid_input)

        expect(result).to eq(valid_input)
      end

      it 'return the input if input is first columns index' do
        first_col_index = 0
        valid_input = first_col_index
        result = game_given_input.verify_input(valid_input)

        expect(result).to eq(valid_input)
      end

      it 'return the input if input is last columns index' do
        last_col_index = 6
        valid_input = last_col_index
        result = game_given_input.verify_input(valid_input)

        expect(result).to eq(valid_input)
      end

      it 'return nil if input is out of bound' do
        invalid_input = 100
        result = game_given_input.verify_input(invalid_input)

        expect(result).to be_nil
      end
    end
  end

  describe '#get_input' do
    subject(:game) { described_class.new }
    let(:error_message) { 'Invalid input. Please try again.' }

    context 'when given a valid input' do
      it 'return the valid input num' do
        valid_input = '3'
        allow(game).to receive(:gets).and_return(valid_input)
        result = game.get_input
        expected_return_value = 3

        expect(result).to eq(expected_return_value)
      end

      it 'does not output exception' do
        valid_input = '3'
        allow(game).to receive(:gets).and_return(valid_input)

        expect(game).to_not receive(:puts).with(error_message)

        game.get_input
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
        result = game.get_input
        expected_return_value = 3

        expect(result).to eq(expected_return_value)
      end

      it 'do output exception' do
        expect(game).to receive(:puts).with(error_message).once

        game.get_input
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

        game.get_input
      end

      it 'return valid input num at the end' do
        result = game.get_input
        expected_return_value = 3

        expect(result).to eq(expected_return_value)
      end
    end
  end
end
