# frozen_string_literal: true

require_relative '../../../lib/toy_on_table/services/output_writer'

describe ToyOnTable::Services::OutputWriter do
  describe '.initialize' do
    it 'sets file_path' do
      service = ToyOnTable::Services::OutputWriter.new('my_path/my_file')

      expect(service.file_path).to eq 'my_path/my_file'
    end
  end

  describe '.append' do
    it 'appends the given string to the file' do
      File.open('test.txt', 'w+') { |file| file.puts('hi') }
      ToyOnTable::Services::OutputWriter.new('test.txt').append('hello')
      ToyOnTable::Services::OutputWriter.new('test.txt').append('billa')

      expect(File.readlines('test.txt').map(&:strip)).to match_array %w[hi hello billa]

      File.delete('test.txt')
    end
  end
end
