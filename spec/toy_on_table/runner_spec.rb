# frozen_string_literal: true

require_relative '../../lib/toy_on_table/runner'

describe ToyOnTable::Runner do
  describe '.initialize' do
    it 'sets up the required instance variables correctly' do
      runner = ToyOnTable::Runner.new(input_file_path: 'spec/fixtures/toy_on_table/sample_input.txt', output_file_path: 'spec_output.txt')

      toy = runner.instance_variable_get(:@toy)
      input_service = runner.instance_variable_get(:@read_input_service)

      expect(toy.table).to be_a ToyOnTable::Models::Table
      expect(toy.reporting_target.file_path).to eq 'spec_output.txt'
      expect(input_service.file_path).to eq 'spec/fixtures/toy_on_table/sample_input.txt'
    end
  end

  describe '#run' do
    it 'reads the input data, processes the input and write the output' do
      ToyOnTable::Runner.new(input_file_path: 'spec/fixtures/toy_on_table/sample_input.txt', output_file_path: 'spec_output.txt').run

      computed_output_lines = File.readlines(File.join(File.dirname(__FILE__), '../../spec_output.txt')).map(&:strip)
      expected_output_lines = File.readlines(File.join(File.dirname(__FILE__), '../../spec/fixtures/toy_on_table/sample_output.txt')).map(&:strip)

      expect(computed_output_lines).to eq expected_output_lines

      File.delete('spec_output.txt')
    end

    it 'validates commands and only executes valid commands' do
      runner = ToyOnTable::Runner.new(input_file_path: 'spec/fixtures/toy_on_table/invalid_command.txt', output_file_path: 'spec_output.txt')

      expect_any_instance_of(ToyOnTable::Models::Command).to receive(:validate)
      expect_any_instance_of(ToyOnTable::Models::Toy).not_to receive(:execute)

      runner.run

      File.delete('spec_output.txt')
    end

    context 'multiple test cases' do
      it 'works as expected in all cases' do
        test_cases = [
          {
            input_lines: [],
            expected_output_lines: []
          },
          {
            input_lines: ['PLACE 0,0,NORTH', 'LEFT', 'REPORT'],
            expected_output_lines: ['0,0,WEST']
          },
          {
            input_lines: ['PLACE 0,0,NORTH', 'MOVE', 'REPORT'],
            expected_output_lines: ['0,1,NORTH']
          },
          {
            input_lines: ['INVALID_COMMAND'],
            expected_output_lines: []
          },
          {
            input_lines: ['PLACE 9,9,NORTH', 'REPORT'],
            expected_output_lines: ['Not placed on table']
          },
          {
            input_lines: ['PLACE 2,3,NORTH', 'REPORT', 'MOVE', 'REPORT'],
            expected_output_lines: ['2,3,NORTH', '2,4,NORTH']
          },
          {
            input_lines: ['PLACE 2,3,NORTH', 'REPORT', 'MOVE', 'REPORT', 'PLACE 12,13,NORTH', 'REPORT'],
            expected_output_lines: ['2,3,NORTH', '2,4,NORTH', '2,4,NORTH']
          },
          {
            input_lines: ['PLACE 2,3,NORTH', 'REPORT', 'MOVE', 'REPORT', 'PLACE 12,13,NORTH', 'REPORT', 'PLACE 1,1,NORTH', 'REPORT'],
            expected_output_lines: ['2,3,NORTH', '2,4,NORTH', '2,4,NORTH', '1,1,NORTH']
          },
          {
            input_lines: ['PLACE 2,3,NORTH', 'REPORT', 'INVALID', 'REPORT', 'PLACE 2,3,NORTHEAST', 'REPORT'],
            expected_output_lines: ['2,3,NORTH', '2,3,NORTH', '2,3,NORTH']
          },
          {
            input_lines: ['PLACE 0,0,EAST', 'MOVE', 'MOVE', 'LEFT', 'MOVE', 'LEFT', 'MOVE', 'RIGHT', 'MOVE', 'REPORT'],
            expected_output_lines: ['1,2,NORTH']
          },
          {
            input_lines: ['PLACE 0,0,NORTH', 'MOVE', 'MOVE', 'LEFT', 'MOVE', 'LEFT', 'MOVE', 'MOVE', 'REPORT'],
            expected_output_lines: ['0,0,SOUTH']
          },
          {
            input_lines: ['PLACE 0,0,NORTH', 'MOVE', 'MOVE', 'LEFT', 'MOVE', 'LEFT', 'MOVE', 'MOVE', 'LEFT', 'REPORT'],
            expected_output_lines: ['0,0,EAST']
          },
          {
            input_lines: ['PLACE 1,2,NORTH', 'MOVE', 'MOVE', 'LEFT', 'MOVE', 'RIGHT', 'MOVE', 'MOVE', 'LEFT', 'REPORT'],
            expected_output_lines: ['0,4,WEST']
          },
          {
            input_lines: ['PLACE 4,4,EAST', 'MOVE', 'MOVE', 'LEFT', 'REPORT'],
            expected_output_lines: ['4,4,NORTH']
          },
          {
            input_lines: ['PLACE 4,4,NORTH', 'MOVE', 'MOVE', 'LEFT', 'REPORT'],
            expected_output_lines: ['4,4,WEST']
          },
          {
            input_lines: ['PLACE 4,2, EAST', 'MOVE', 'REPORT'],
            expected_output_lines: ['4,2,EAST']
          },
          {
            input_lines: ['PLACE 2,0, SOUTH', 'MOVE', 'REPORT'],
            expected_output_lines: ['2,0,SOUTH']
          },
          {
            input_lines: ['PLACE 2,4, NORTH', 'MOVE', 'REPORT'],
            expected_output_lines: ['2,4,NORTH']
          },
          {
            input_lines: ['PLACE 0,4,WEST', 'MOVE', 'REPORT'],
            expected_output_lines: ['0,4,WEST']
          }
        ]

        test_cases.each do |test_case|
          runner = ToyOnTable::Runner.new(input_file_path: 'random', output_file_path: 'spec_output.txt')

          input_lines = test_case[:input_lines]
          input_enumerator = input_lines.each
          expected_output_lines = test_case[:expected_output_lines]

          runner.send(:process_input, input_enumerator)

          computed_output_lines = File.readlines('spec_output.txt').map(&:strip)
          expect(computed_output_lines).to eq expected_output_lines

          File.delete('spec_output.txt')
        end
      end
    end
  end
end
