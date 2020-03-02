# frozen_string_literal: true

module ToyOnTable
  module Services
    class Logger
      class << self
        attr_accessor :skip_logging
      end

      def self.log(content)
        puts content unless skip_logging == true
      end
    end
  end
end
