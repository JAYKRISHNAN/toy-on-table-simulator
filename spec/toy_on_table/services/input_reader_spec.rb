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
    it 'returns a lazy iterator that iterates over the input lines' do
      file_path = 'test.txt'
      commands = ['TEST COMMAND 1', 'TEST COMMAND 2']
      File.open(file_path, 'w+') do |file|
        commands.each { |element| file.puts(element) }
      end
      reader = ToyOnTable::Services::InputReader.new(file_path)
      input_enumerator = reader.input_enumerator

      expect(input_enumerator.next).to eq "TEST COMMAND 1\n"
      expect(input_enumerator.next).to eq "TEST COMMAND 2\n"

      File.delete('test.txt')
    end
  end
end
