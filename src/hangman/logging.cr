require "logger"

module Hangman::Logging
  # :nodoc:
  LOGGER = Logger.new(STDOUT).tap do |l|
    l = Logger.new(STDOUT)
    l.level = Logger::INFO
  end

  def self.logger
    LOGGER
  end
end
