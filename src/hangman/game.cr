class Hangman::Game
  VALID_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".chars

  property attempts = [] of Char
  property drawing_state = DrawingState::Empty
  @word : String

  enum DrawingState
    Empty
    Head
    Torso
    OneArm
    TwoArms
    OneLeg
    TwoLegs

    def next
      DrawingState.new(value + 1)
    end
  end

  def initialize(word : String)
    @word = word.upcase
    validate_word
  end

  def try_letter(letter : Char)
    letter = letter.upcase
    raise "Game already finished" if finished?
    raise "Letter tried more than once" if attempts.includes? letter
    attempts << letter

    success = @word.chars.includes? letter

    if !success
      @drawing_state = drawing_state.next
    end

    success
  end

  def finished?
    is_victory? || is_defeat?
  end

  def is_victory?
    attempts.sort == @word.chars.uniq.sort
  end

  def is_defeat?
    drawing_state == DrawingState::TwoLegs
  end

  private def validate_word
    raise "Word must not be empty" if @word.empty?

    unless @word.chars.all? { |c| VALID_CHARS.includes? c }
      raise "Word contains unknown characters"
    end
  end
end
