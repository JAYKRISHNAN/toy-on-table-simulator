# frozen_string_literal: true

require_relative '../../../lib/toy_on_table/models/table_cell'
require_relative '../../../lib/toy_on_table/models/table'
require_relative '../../../lib/toy_on_table/models/toy'
require_relative '../../../lib/toy_on_table/models/command'

describe ToyOnTable::Models::Toy do
  describe '.initialize' do
    it 'sets the table and reporting channel' do
      table = ToyOnTable::Models::Table.new(2, 3)
      reporting_target = ToyOnTable::Services::OutputWriter.new('test.txt')

      toy = ToyOnTable::Models::Toy.new(table: table, reporting_target: reporting_target)

      expect(toy.table).to eq table
      expect(toy.reporting_target).to eq reporting_target
    end
  end

  describe '.execute' do
    let(:table) { ToyOnTable::Models::Table.new(5, 5) }
    let(:reporting_target) { ToyOnTable::Services::OutputWriter.new('test.txt') }
    let(:toy) { ToyOnTable::Models::Toy.new(table: table, reporting_target: reporting_target) }

    it 'executes the given command' do
      command = ToyOnTable::Models::Command.new('PLACE 2,3,EAST')
      command.format_arguments!

      toy.execute(command)

      expect(toy.position.x_coordinate).to eq 2
      expect(toy.position.y_coordinate).to eq 3
      expect(toy.direction).to eq :east
    end

    it 'ignores any command that makes it fall of table' do
      command = ToyOnTable::Models::Command.new('PLACE 4,4,EAST')
      command.format_arguments!
      toy.execute(command)
      falling_command = ToyOnTable::Models::Command.new('MOVE')

      expect(toy.execute(falling_command)).to be_falsey
    end

    it 'logs a warning message if the commad makes toy fall of table' do
      command = ToyOnTable::Models::Command.new('PLACE 4,4,EAST')
      command.format_arguments!
      toy.execute(command)
      falling_command = ToyOnTable::Models::Command.new('MOVE')

      expect { toy.execute(falling_command) }.to output("Attempted move will make the toy fall. Hence ignored.\n").to_stdout
    end

    it 'ignores all commands until a valid PLACE command is given to it' do
      command1 = ToyOnTable::Models::Command.new('MOVE')

      expect(toy.execute(command1)).to be_falsey
      expect(toy.position).to be_nil

      command = ToyOnTable::Models::Command.new('PLACE 2,3,EAST')
      command.format_arguments!
      toy.execute(command)
      expect(toy.execute(command1)).to be_truthy

      expect(toy.position.x_coordinate).to eq 3
      expect(toy.position.y_coordinate).to eq 3
      expect(toy.direction).to eq :east
    end

    context 'PLACE command' do
      it 'places the toy in given position and orientation' do
        command = ToyOnTable::Models::Command.new('PLACE 2,3,EAST')
        command.format_arguments!

        toy.execute(command)

        expect(toy.position.x_coordinate).to eq 2
        expect(toy.position.y_coordinate).to eq 3
        expect(toy.direction).to eq :east
      end

      it 'ignores the place command if it makes toy fall of table' do
        command = ToyOnTable::Models::Command.new('PLACE 12,13,EAST')
        command.format_arguments!

        toy.execute(command)

        expect(toy.position).to be_nil
      end
    end

    context 'LEFT command' do
      it 'rotates toy 90 degreed to the left' do
        command = ToyOnTable::Models::Command.new('PLACE 2,3,EAST')
        command.format_arguments!
        toy.execute(command)

        toy.execute(ToyOnTable::Models::Command.new('LEFT'))
        expect(toy.direction).to eq :north
        toy.execute(ToyOnTable::Models::Command.new('LEFT'))
        expect(toy.direction).to eq :west
        toy.execute(ToyOnTable::Models::Command.new('LEFT'))
        expect(toy.direction).to eq :south
        toy.execute(ToyOnTable::Models::Command.new('LEFT'))
        expect(toy.direction).to eq :east
      end
    end

    context 'RIGHT command' do
      it 'rotates toy 90 degreed to the left' do
        command = ToyOnTable::Models::Command.new('PLACE 2,3,EAST')
        command.format_arguments!
        toy.execute(command)

        toy.execute(ToyOnTable::Models::Command.new('RIGHT'))
        expect(toy.direction).to eq :south
        toy.execute(ToyOnTable::Models::Command.new('RIGHT'))
        expect(toy.direction).to eq :west
        toy.execute(ToyOnTable::Models::Command.new('RIGHT'))
        expect(toy.direction).to eq :north
        toy.execute(ToyOnTable::Models::Command.new('RIGHT'))
        expect(toy.direction).to eq :east
      end
    end

    context 'MOVE command' do
      it 'moves the toy one step in the current direction' do
        command = ToyOnTable::Models::Command.new('PLACE 2,3,EAST')
        command.format_arguments!
        toy.execute(command)

        toy.execute(ToyOnTable::Models::Command.new('MOVE'))
        expect(toy.position.x_coordinate).to eq 3
      end

      it 'ignores the comand if it makes it fall off the table' do
        command = ToyOnTable::Models::Command.new('PLACE 4,4,EAST')
        command.format_arguments!
        toy.execute(command)

        toy.execute(ToyOnTable::Models::Command.new('MOVE'))
        expect(toy.position.x_coordinate).to eq 4
      end
    end

    context 'REPORT command' do
      it 'reports the current state' do
        command = ToyOnTable::Models::Command.new('PLACE 2,3,EAST')
        command.format_arguments!
        toy.execute(command)

        expect(reporting_target).to receive(:append).with('2,3,EAST')

        toy.execute(ToyOnTable::Models::Command.new('REPORT'))
      end

      it 'reports state if it is not on any table' do
        expect(reporting_target).to receive(:append).with('Not placed on table')

        toy.execute(ToyOnTable::Models::Command.new('REPORT'))
      end
    end
  end
end
