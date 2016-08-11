#! env crystal
require "../src/hangman"

include Hangman

server = Hangman::Server.new("0.0.0.0", 8000)
puts "Hangman is up and running :-)"
server.listen
