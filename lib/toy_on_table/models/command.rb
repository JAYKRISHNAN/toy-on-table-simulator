require 'pry-byebug'
require_relative '../services/logger'
require_relative '../exceptions'

module ToyOnTable
  module Models
    class Command
      COMMAND_NAMES_WITHOUT_ARGUMENTS = %i[move left right report].freeze
      COMMAND_NAMES_WITH_ARGUMENTS = [:place].freeze
      VALID_DIRECTIONS = %i[north east south west].freeze

      attr_reader :name, :arguments, :index

      def initialize(raw_input_line, index)
        set_name_and_arguments!(raw_input_line)
        @index = index
      end

      def validate
        validate_name && validate_arguments
      rescue Exceptions::InvalidCommand, Exceptions::InvalidArguments => e
        log_exception e
        false
      end

      def format_arguments!
        unless arguments.empty?
          @arguments = send("format_#{name}_command_arguments")
        end
      end

      private

      def set_name_and_arguments!(input_line)
        raw_name = input_line.split(' ')[0]
        raw_arguments = input_line.split(' ')[1]

        @name = raw_name.downcase.to_sym
        @arguments = raw_arguments ? raw_arguments.split(",") : []
      end

      def valid_command_names
        COMMAND_NAMES_WITH_ARGUMENTS + COMMAND_NAMES_WITHOUT_ARGUMENTS
      end

      def validate_name
        if valid_command_names.include?(name)
          true
        else
          raise Exceptions::InvalidCommand, self
          false
        end
      end

      def validate_arguments
        if COMMAND_NAMES_WITHOUT_ARGUMENTS.include?(name)
          validate_no_arguments
        else
          send("validate_#{name}_command_arguments")
        end
      end

      def validate_no_arguments
        if @arguments.empty?
          true
        else
          raise Exceptions::InvalidArguments, self
          false
        end
      end

      def validate_place_command_arguments
        if valid_place_command_arguments?
          true
        else
          raise Exceptions::InvalidArguments, self
          false
        end
      end

      def valid_place_command_arguments?
        x_coordinate, y_coordinate, direction = arguments

        (arguments.count == 3) &&
          positive_integer?(x_coordinate) &&
          positive_integer?(y_coordinate) &&
          valid_direction?(direction)
      end

      def positive_integer?(variable)
        variable.to_i.to_s == variable
      end

      def valid_direction?(direction)
        VALID_DIRECTIONS.include?(direction.downcase.to_sym)
      end

      def format_place_command_arguments
        x_coordinate, y_coordinate, direction = arguments
        [x_coordinate.to_i, y_coordinate.to_i, direction.downcase.to_sym]
      end

      def log_exception(exception)
        Services::Logger.log exception.message
      end
    end
  end
end
