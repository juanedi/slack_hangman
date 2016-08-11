require "./**"
require "logger"

module Hangman
  extend self

  delegate logger, to: Hangman::Logging
end
