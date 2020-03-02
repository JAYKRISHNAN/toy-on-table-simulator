# frozen_string_literal: true

require_relative 'table_cell'

module ToyOnTable
  module Models
    class Table
      attr_accessor :row_count, :column_count

      def initialize(row_count, column_count)
        @row_count = row_count
        @column_count = column_count
      end

      # not <= because array indices start with 0 not 1
      def include?(table_cell)
        (table_cell.row_number < @row_count) &&
          (table_cell.column_number < @column_count)
      end
    end
  end
end
