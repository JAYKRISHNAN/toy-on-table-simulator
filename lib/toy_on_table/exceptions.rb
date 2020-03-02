# frozen_string_literal: true

require_relative './models/command'

module ToyOnTable
  module Exceptions
    class InvalidCommand < StandardError
      def initialize(command)
        if command.index
          super("Command #{command.index + 1} : #{command.name}, is an invalid command")
        else
          super("Command : #{command.name}, is an invalid command")
        end
      end
    end

    class InvalidArguments < StandardError
      def initialize(command)
        if command.index
          super("Invalid arguments #{command.arguments.map(&:to_s).join(',')} : passed to command #{command.index + 1} #{command.name}")
        else
          super("Invalid arguments #{command.arguments.map(&:to_s).join(',')} : passed to command #{command.name}")
        end
      end
    end
  end
end
