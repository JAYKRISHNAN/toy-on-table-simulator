# frozen_string_literal: true

module ToyOnTable
  module Models
    class TableCell
      attr_accessor :x_coordinate, :y_coordinate

      alias row_number x_coordinate
      alias column_number y_coordinate

      def initialize(x_coordinate, y_coordinate)
        @x_coordinate = x_coordinate
        @y_coordinate = y_coordinate
      end
    end
  end
end
