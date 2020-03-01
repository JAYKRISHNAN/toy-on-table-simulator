# frozen_string_literal: true

require_relative '../models/command'

module ToyOnTable
  module Services
    class InputReader
      def initialize(file_path)
        @file_path = file_path
      end

      def read
        commands = []
        File.readlines(File.join(File.dirname(__FILE__), "../../../#{@file_path}")).each_with_index do |line, index|
          commands << Models::Command.new(line, index)
        end
        commands
      end
    end
  end
end
