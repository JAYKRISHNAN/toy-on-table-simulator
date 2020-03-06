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

      def include?(table_cell)
        within_row_limts?(table_cell) && within_column_limits?(table_cell)
      end

      private

      # not <= because array indices start with 0 not 1
      def within_row_limts?(table_cell)
        (table_cell.row_number >= 0) && (table_cell.row_number < @row_count)
      end

      # not <= because array indices start with 0 not 1
      def within_column_limits?(table_cell)
        (table_cell.column_number >= 0) && (table_cell.column_number < @column_count)
      end
    end
  end
end
