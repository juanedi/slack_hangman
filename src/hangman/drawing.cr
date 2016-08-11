module Hangman::Drawing
  extend self

  def ascii(state : Game::DrawingState)
    case state
    when Game::DrawingState::Empty
      draw_empty
    when Game::DrawingState::Head
      draw_head
    when Game::DrawingState::Torso
      draw_torso
    when Game::DrawingState::OneArm
      draw_one_arm
    when Game::DrawingState::TwoArms
      draw_two_arms
    when Game::DrawingState::OneLeg
      draw_one_leg
    when Game::DrawingState::TwoLegs
      draw_two_legs
    end
  end

  private def draw_empty
    <<-ASCII
       _______
     |/      |
     |
     |
     |
     |
     |
    _|___
    ASCII
  end

  private def draw_head
    <<-ASCII
       _______
     |/      |
     |      (_)
     |
     |
     |
     |
    _|___
    ASCII
  end

  private def draw_torso
    <<-ASCII
      _______
     |/      |
     |      (_)
     |       |
     |       |
     |
     |
    _|___
    ASCII
  end

  private def draw_one_arm
    <<-ASCII
      _______
     |/      |
     |      (_)
     |       |_/
     |       |
     |
     |
    _|___
    ASCII
  end

  private def draw_two_arms
    <<-ASCII
       _______
     |/      |
     |      (_)
     |     \\\_|_/
     |       |
     |
     |
    _|___
    ASCII
  end

  private def draw_one_leg
    <<-ASCII
       _______
     |/      |
     |      (_)
     |     \\\_|_/
     |       |
     |     _/
     |
    _|___
    ASCII
  end

  private def draw_two_legs
    <<-ASCII
       _______
     |/      |
     |      (_)
     |     \\\_|_/
     |       |
     |     _/ \\\_
     |
    _|___
    ASCII
  end
end
