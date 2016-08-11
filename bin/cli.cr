#! env crystal
require "../src/hangman"

include Hangman

if ARGV.size != 1
  puts "Usage: ./hangman [WORD]"
  exit 1
end

word = ARGV[0]
game = Game.new(word)

until game.finished?
  display(game)

  STDOUT << "Please enter a letter: "
  STDOUT.flush
  input = gets.not_nil!.chomp

  begin
    game.try_letter input.chars[0]
  rescue ex
    puts ex.message
  end
end

display(game)
if game.is_victory?
  puts "Wow that was amazing!"
else
  puts "Oops, you lost. The word was \"#{word}\". Better luck next time!"
end

def display(game)
  puts
  puts game.draw
  puts
  puts game.hint.map { |c| c || '_' }.join(" ")
  puts
end
