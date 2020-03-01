# frozen_string_literal: true

require_relative './models/command'

module ToyOnTable
  module Exceptions
    class InvalidCommand < StandardError
      def initialize(command)
        super("Command #{command.index + 1} #{command.name} is an invalid command")
      end
    end

    class InvalidArguments < StandardError
      def initialize(command)
        super("Invalid arguments #{command.arguments.map(&:to_s).join(',')} passed to command #{command.index + 1} #{command.name}")
      end
    end
  end
end
