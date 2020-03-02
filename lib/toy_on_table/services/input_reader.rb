# frozen_string_literal: true

require_relative '../models/command'

module ToyOnTable
  module Services
    class InputReader
      attr_accessor :file_path

      def initialize(file_path)
        @file_path = file_path
      end

      def read
        path = File.join(File.dirname(__FILE__), "../../../#{file_path}")
        File.readlines(path).each_with_index.map do |line, index|
          Models::Command.new(line.strip, index)
        end
      end
    end
  end
end
