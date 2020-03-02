# frozen_string_literal: true

module ToyOnTable
  module Services
    class OutputWriter
      attr_accessor :file_path

      def initialize(file_path)
        @file_path = file_path
      end

      def append(content)
        path = File.join(File.dirname(__FILE__), "../../../#{file_path}")
        File.open(path, 'a') do |file|
          file.puts content
        end
      end
    end
  end
end
