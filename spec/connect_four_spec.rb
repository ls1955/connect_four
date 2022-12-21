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

  describe '#player_input' do
    subject(:game) { described_class.new }
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
    subject(:game) { described_class.new }

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

  describe '#insert_to_board_col' do
    subject(:game) { described_class.new }
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
        board_pos = game.instance_variable_get(:@board)[col_num][insert_pos]

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
        board_pos = game.instance_variable_get(:@board)[col_num][insert_pos]

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

  <<~TODO
    Well.. lets see.
    Looks like the game is almost finished..?
    ..Nah, probably not.
    Well.. Guess I will need to check the good ol
    horizontal line, vertical line, and diagonal line
    Oh well.
    At least I could implement sliding window for
    horizontal and vertical line check....
    Afterward, what next?
    ..Right, the 'main' function of the game is not
    yet implemented. Since all it does is send message
    to other methods. ..Should I test that method?
    ..Nah, probably not.
    Anyway, I still need to have an intro function,
    and outro function..
    ..and right, printing the board between the round.
    That will be fun.
    ..Sigh, I don't want to imagine what will be like
    for the Ruby last project.
    Well, I am certainly.. looking forward for it

    ..Alright, I am digressing.
    Basically, for a short TLDR:

    Implement check game winning and over conditions methods.
    Implement main method.
    Implement intro and outro method.

    PS: since now game could check for
    whether col is full, looks like I
    could add a new check in verify input
  TODO

  describe '#board_full?' do
    subject(:game) { described_class.new }

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
    subject(:game) { described_class.new }

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
