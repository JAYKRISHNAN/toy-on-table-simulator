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
  end
end
