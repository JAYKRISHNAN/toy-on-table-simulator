# frozen_string_literal: true

require_relative '../../lib/toy_on_table/runner'

describe ToyOnTable::Runner do
  it 'reads the input data, processes the input and write the output' do
    ToyOnTable::Runner.new(input_file_path: 'spec/fixtures/toy_on_table/sample_input.txt', output_file_path: 'spec_output.txt').run

    computed_output_lines = File.readlines(File.join(File.dirname(__FILE__), '../../spec_output.txt'))
    expected_output_lines = File.readlines(File.join(File.dirname(__FILE__), '../../spec/fixtures/toy_on_table/sample_output.txt'))

    expect(computed_output_lines).to eq expected_output_lines

    File.delete('spec_output.txt')
  end
end
