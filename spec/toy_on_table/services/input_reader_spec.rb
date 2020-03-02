# frozen_string_literal: true

require_relative '../../../lib/toy_on_table/models/command'
require_relative '../../../lib/toy_on_table/services/input_reader'

describe ToyOnTable::Services::InputReader do
  describe '.initialize' do
    it 'sets file_path' do
      service = ToyOnTable::Services::InputReader.new('my_path/my_file')

      expect(service.file_path).to eq 'my_path/my_file'
    end
  end

  describe '.read' do
    it 'reads file line by line, strips unwanted characters from each line and returns a list of commands with given input lines' do
      file_path = 'test.txt'
      commands = ['TEST COMMAND 1', 'TEST COMMAND 2']
      File.open(file_path, 'w+') do |file|
        commands.each { |element| file.puts(element) }
      end
      reader = ToyOnTable::Services::InputReader.new(file_path)

      expect(ToyOnTable::Models::Command).to receive(:new).with('TEST COMMAND 1', 0).and_call_original
      expect(ToyOnTable::Models::Command).to receive(:new).with('TEST COMMAND 2', 1).and_call_original

      commands = reader.read

      commands.each do |command|
        expect(command).to be_a ToyOnTable::Models::Command
      end

      File.delete('test.txt')
    end
  end
end
