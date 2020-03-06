# frozen_string_literal: true

require 'fileutils'
require 'pry-byebug'

require_relative 'services/input_reader'
require_relative 'constants'
require_relative 'models/toy'
require_relative 'models/table'

module ToyOnTable
  class Runner
    def initialize(input_file_path:, output_file_path:)
      setup_output_file output_file_path
      @read_input_service = Services::InputReader.new(input_file_path)
      write_output_service = Services::OutputWriter.new(output_file_path)
      table = Models::Table.new(Constants::TABLE_ROW_COUNT, Constants::TABLE_COLUMN_COUNT)
      @toy = Models::Toy.new(table: table, reporting_target: write_output_service)
    end

    def run
      process_input(@read_input_service.input_enumerator)
    end

    private

    def setup_output_file(output_file_path)
      FileUtils.touch(output_file_path)
      File.truncate(output_file_path, 0)
    end

    def process_input(input_enumerator)
      command_index = 0
      loop do
        line = input_enumerator.next
        command = Models::Command.new(line.strip, command_index)
        next unless command.validate

        execute_command command
        command_index += 1
      end
    end

    def execute_command(command)
      command.format_arguments!
      @toy.execute(command)
    end
  end
end
