require "../spec_helper"

describe Hangman::Game do
  describe "chosen word" do
    it "cannot be empty" do
      expect_raises { Game.new("") }
    end

    it "cannot contain spaces" do
      expect_raises { Game.new("foo bar") }
    end

    it "cannot contain unknown characters" do
      expect_raises { Game.new("*") }
    end
  end

  describe "initial state" do
    it "starts with empty drawing" do
      game = Hangman::Game.new("hello")
      game.drawing_state.should eq(Game::DrawingState::Empty)
    end

    it "starts with empty attempts list" do
      game = Hangman::Game.new("hello")
      game.attempts.should eq([] of Char)
    end

    it "is not considered finished just after starting" do
      game = Hangman::Game.new("hello")
      game.finished?.should eq(false)
    end
  end

  describe "successful attempt" do
    it "returns true" do
      game = Hangman::Game.new("hello")
      game.try_letter('e').should eq(true)
    end

    it "is tracked" do
      game = Hangman::Game.new("hello")

      game.try_letter 'E'
      game.attempts.should eq(['E'])
      game.try_letter 'H'
      game.attempts.should eq(['E', 'H'])
      game.try_letter 'L'
      game.attempts.should eq(['E', 'H', 'L'])
      game.try_letter 'O'
      game.attempts.should eq(['E', 'H', 'L', 'O'])
    end

    it "does not alter drawing state" do
      game = Hangman::Game.new("hello")
      game.try_letter 'E'
      game.drawing_state.should eq(Game::DrawingState::Empty)
    end

    it "is case insensitive" do
      game = Hangman::Game.new("hello")
      game.try_letter 'e'
      game.drawing_state.should eq(Game::DrawingState::Empty)
      game.attempts.should eq(['E'])
    end
  end

  describe "failed attempt" do
    it "returns false" do
      game = Hangman::Game.new("hello")
      game.try_letter('j').should eq(false)
    end

    it "is tracked" do
      game = Hangman::Game.new("hello")

      game.try_letter 'j'
      game.attempts.should eq(['J'])
      game.try_letter 'p'
      game.attempts.should eq(['J', 'P'])
    end

    it "advances drawing state" do
      game = Hangman::Game.new("hello")

      game.try_letter 'j'
      game.drawing_state.should eq(Game::DrawingState::Head)
      game.try_letter 'k'
      game.drawing_state.should eq(Game::DrawingState::Torso)
      game.try_letter 'm'
      game.drawing_state.should eq(Game::DrawingState::OneArm)
      game.try_letter 'n'
      game.drawing_state.should eq(Game::DrawingState::TwoArms)
      game.try_letter 'p'
      game.drawing_state.should eq(Game::DrawingState::OneLeg)
      game.try_letter 'q'
      game.drawing_state.should eq(Game::DrawingState::TwoLegs)
    end
  end

  describe "game ending" do
    it "ends with victory if word is guessed" do
      game = Hangman::Game.new("hello")

      game.try_letter 'h'
      game.try_letter 'e'
      game.try_letter 'l'
      game.try_letter 'o'

      game.finished?.should eq(true)
      game.is_victory?.should eq(true)
      game.is_defeat?.should eq(false)
    end

    it "ends with defeat if poor man is hung" do
      game = Hangman::Game.new("hello")

      game.try_letter 'j'
      game.try_letter 'k'
      game.try_letter 'm'
      game.try_letter 'n'
      game.try_letter 'p'
      game.try_letter 'q'

      game.finished?.should eq(true)
      game.is_victory?.should eq(false)
      game.is_defeat?.should eq(true)
    end

    it "recognizes victory even if there were failed attempts" do
      # bugfix
      game = Hangman::Game.new("here")

      game.try_letter 'i'

      game.try_letter 'h'
      game.try_letter 'e'
      game.try_letter 'r'

      game.finished?.should eq(true)
    end

    it "does not accept new attempts after finished" do
      game = Game.new("ok")
      game.try_letter 'o'
      game.try_letter 'k'

      expect_raises { game.try_letter 'l' }
    end
  end

  it "does not allow to try a letter more than once" do
    game = Hangman::Game.new("hello")
    game.try_letter 'e'

    expect_raises { game.try_letter 'e' }
  end

  it "informs a hint with succesfull attempts" do
    game = Hangman::Game.new("redundant")

    game.try_letter 'r'
    game.try_letter 'd'
    game.try_letter 'x'

    game.hint.should eq(['R', nil, 'D', nil, nil, 'D', nil, nil, nil])
  end
end
