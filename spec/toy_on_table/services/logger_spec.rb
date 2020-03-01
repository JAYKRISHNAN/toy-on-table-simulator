# frozen_string_literal: true

require_relative '../../../lib/toy_on_table/services/logger'

describe ToyOnTable::Services::Logger do
  describe '.log' do
    it 'prints the given content to console in a new line' do
      logger = ToyOnTable::Services::Logger

      expect { logger.log('hi') }.to output("hi\n").to_stdout
    end
  end
end
