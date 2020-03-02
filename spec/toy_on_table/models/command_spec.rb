# frozen_string_literal: true

require_relative '../../../lib/toy_on_table/models/command'

describe ToyOnTable::Models::Command do
  describe '.initialize' do
    it 'sets the index, name and the arguments of the command given raw input line - case without arguments' do
      command = ToyOnTable::Models::Command.new('COMMAND1', 2)

      expect(command.name).to eq :command1
      expect(command.index).to eq 2
      expect(command.arguments).to match_array([])
    end

    it 'sets the index, name and the arguments of the command given raw input line - case with arguments' do
      command = ToyOnTable::Models::Command.new('COMMAND1 A,B,C', 2)

      expect(command.name).to eq :command1
      expect(command.index).to eq 2
      expect(command.arguments).to match_array(%w[A B C])
    end

    it 'does not raise any error if the index is not given' do
      expect { ToyOnTable::Models::Command.new('COMMAND1') }.not_to raise_error
    end
  end

  describe '#format_arguments' do
    it 'does not raise an error if there are no arguments' do
      command = ToyOnTable::Models::Command.new('MOVE', 2)

      expect { command.format_arguments! }.not_to raise_error

      expect(command.arguments).to be_empty
    end

    context 'for commands with arguments' do
      context 'PLACE command' do
        it 'sets the coordinates as integer and direction as symbol' do
          command = ToyOnTable::Models::Command.new('PLACE 1,2,NORTH', 2)

          command.format_arguments!

          expect(command.arguments).to match_array [1, 2, :north]
        end
      end
    end
  end

  describe '#validate' do
    context 'valid' do
      it 'returns true if the command is a valid one' do
        command = ToyOnTable::Models::Command.new('MOVE')

        expect(command.validate).to be_truthy
      end
    end

    context 'invalid' do
      it 'returns false if the command is an invalid one' do
        command = ToyOnTable::Models::Command.new('INVALID COMMAND')

        expect(command.validate).to be_falsey
      end

      it 'logs warning message if the command name is an invalid' do
        command = ToyOnTable::Models::Command.new('SHOOT', 3)

        expect { command.validate }.to output("Command 4 : shoot, is an invalid command\n").to_stdout
      end

      it 'logs warning message if the command does not expect arguments and arguments are given' do
        command = ToyOnTable::Models::Command.new('MOVE 2', 3)

        expect { command.validate }.to output("Invalid arguments 2 : passed to command 4 move\n").to_stdout
      end

      it 'logs warning message if incorrect arguments are given to the command' do
        command = ToyOnTable::Models::Command.new('PLACE EAST', 3)

        expect { command.validate }.to output("Invalid arguments EAST : passed to command 4 place\n").to_stdout
      end
    end

    context 'PLACE command' do
      it 'returns true if all the arguments are valid' do
        command = ToyOnTable::Models::Command.new('PLACE 0,0,EAST', 2)

        expect(command.validate).to be_truthy
      end

      it 'returns false if argument count or any argument is incorrect' do
        command1 = ToyOnTable::Models::Command.new('PLACE 2,3', 2)
        command2 = ToyOnTable::Models::Command.new('PLACE -2,3,EAST', 2)
        command3 = ToyOnTable::Models::Command.new('PLACE a,3,EAST', 2)
        command4 = ToyOnTable::Models::Command.new('PLACE 2,3,NORTHEAST', 2)
        command5 = ToyOnTable::Models::Command.new('PLACE 2,4.2,EAST', 2)
        command6 = ToyOnTable::Models::Command.new('PLACE 2.1,3,EAST', 2)

        6.times do |index|
          expect(eval("command#{index + 1}").validate).to be_falsey
        end
      end
    end
  end
end
