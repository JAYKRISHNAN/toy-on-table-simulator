# frozen_string_literal: true

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

      def initialize(raw_input_line, index = nil)
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
        return if arguments.empty?

        @arguments = send("formatted_#{name}_command_arguments")
      end

      private

      def set_name_and_arguments!(input_line)
        raw_name = input_line.split(' ')[0]
        arguments = input_line.split(' ').drop(1).join(' ')

        @name = raw_name.downcase.strip.to_sym
        @arguments = arguments ? arguments.split(',').map(&:strip) : []
      end

      def valid_command_names
        COMMAND_NAMES_WITH_ARGUMENTS + COMMAND_NAMES_WITHOUT_ARGUMENTS
      end

      def validate_name
        validate_with_raising_exception(Exceptions::InvalidCommand) { valid_command_names.include?(name) }
      end

      def validate_no_arguments
        validate_with_raising_exception(Exceptions::InvalidArguments) { @arguments.empty? }
      end

      def validate_place_command_arguments
        validate_with_raising_exception(Exceptions::InvalidArguments) { valid_place_command_arguments? }
      end

      def validate_with_raising_exception(exception_class)
        return true if yield

        raise exception_class, self
      end

      def validate_arguments
        if COMMAND_NAMES_WITHOUT_ARGUMENTS.include?(name)
          validate_no_arguments
        else
          send("validate_#{name}_command_arguments")
        end
      end

      def valid_place_command_arguments?
        x_coordinate, y_coordinate, direction = arguments

        (arguments.count == 3) &&
          non_negative_integer?(x_coordinate) &&
          non_negative_integer?(y_coordinate) &&
          valid_direction?(direction)
      end

      def non_negative_integer?(variable)
        (variable.to_i.to_s == variable) && !variable.to_i.negative?
      end

      def valid_direction?(direction)
        VALID_DIRECTIONS.include?(direction.downcase.to_sym)
      end

      def formatted_place_command_arguments
        x_coordinate, y_coordinate, direction = arguments
        [x_coordinate.to_i, y_coordinate.to_i, direction.downcase.to_sym]
      end

      def log_exception(exception)
        Services::Logger.log exception.message
      end
    end
  end
end
