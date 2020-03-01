# frozen_string_literal: true

module ToyOnTable
  module Services
    class OutputWriter
      def initialize(file_path)
        @file_path = file_path
      end

      def append(content)
        file = File.open(File.join(File.dirname(__FILE__), "../../../#{@file_path}"), 'a')
        file.write content
        file.close
      end
   end
  end
end
