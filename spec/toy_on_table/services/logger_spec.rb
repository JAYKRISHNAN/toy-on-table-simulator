# frozen_string_literal: true

require_relative '../../../lib/toy_on_table/services/logger'

describe ToyOnTable::Services::Logger do
  describe '.log' do
    it 'prints the given content to console in a new line' do
      logger = ToyOnTable::Services::Logger

      expect { logger.log('hi') }.to output("hi\n").to_stdout
    end

    it 'does not log the content of configured to skip logging' do
      logger = ToyOnTable::Services::Logger
      logger.skip_logging = true

      expect { logger.log('hi') }.not_to output("hi\n").to_stdout

      logger.skip_logging = false
    end
  end
end
