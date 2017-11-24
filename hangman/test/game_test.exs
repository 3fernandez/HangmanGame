defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns a structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "state ins't changed for :won game" do
    for state <- [ :won, :lost ] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert  { ^game, _ } = Game.make_move(game, "x")
    end
  end

  test "first ocurrence of letter isn't already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second ocurrence of letter is already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used

    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end
end
