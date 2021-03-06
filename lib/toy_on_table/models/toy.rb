# frozen_string_literal: true

require_relative 'table_cell'
require_relative 'table'
require_relative '../services/output_writer'
require_relative '../services/logger'
require 'pry-byebug'

module ToyOnTable
  module Models
    class Toy
      attr_accessor :position, :direction, :table, :reporting_target

      def initialize(table:, reporting_target:)
        @table = table
        @reporting_target = reporting_target
      end

      def execute(command)
        if executable?(command)
          command.arguments.empty? ? send(command.name) : send(command.name, command.arguments)
        else
          false
        end
      end

      private

      def executable?(command)
        on_table? || can_be_executed_without_being_on_table?(command)
      end

      def can_be_executed_without_being_on_table?(command)
        (command.name == :place) || (command.name == :report)
      end

      def report
        reporting_target.append reporting_data
      end

      def on_table?
        @position.is_a? Models::TableCell
      end

      def reporting_data
        if on_table?
          [@position.x_coordinate, @position.y_coordinate, @direction.to_s.upcase].join(',')
        else
          'Not placed on table'
        end
      end

      def place(arguments)
        x_coordinate, y_coordinate, direction = arguments
        next_position = TableCell.new(x_coordinate, y_coordinate)
        if move_to_position(next_position)
          @direction = direction
          true
        else
          false
        end
      end

      def move
        x_coordinate = @position.x_coordinate
        y_coordinate = @position.y_coordinate
        case @direction
        when :north
          y_coordinate += 1
        when :south
          y_coordinate -= 1
        when :east
          x_coordinate += 1
        when :west
          x_coordinate -= 1
        end
        next_position = TableCell.new(x_coordinate, y_coordinate)
        move_to_position(next_position)
      end

      def left
        case @direction
        when :north
          @direction = :west
        when :south
          @direction = :east
        when :east
          @direction = :north
        when :west
          @direction = :south
        end
      end

      def right
        case @direction
        when :north
          @direction = :east
        when :south
          @direction = :west
        when :east
          @direction = :south
        when :west
          @direction = :north
        end
      end

      def move_to_position(position)
        if can_move_to_position? position
          @position = position
          true
        else
          log_message 'Attempted move will make the toy fall. Hence ignored.'
          false
        end
      end

      def can_move_to_position?(position)
        table.include? position
      end

      def log_message(message)
        Services::Logger.log message
      end
    end
  end
end
