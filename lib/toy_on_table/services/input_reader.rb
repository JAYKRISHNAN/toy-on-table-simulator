# frozen_string_literal: true

require_relative '../models/command'

module ToyOnTable
  module Services
    class InputReader
      attr_accessor :file_path

      def initialize(file_path)
        @file_path = file_path
      end

      def input_enumerator
        path = File.join(File.dirname(__FILE__), "../../../#{file_path}")
        File.open(path).each_line.lazy
      end
    end
  end
end
