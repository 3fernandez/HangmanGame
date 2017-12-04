defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns a structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "state ins't changed for :wongame" do
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

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    { game, _tally } = Game.make_move(game, "w")

    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guessed word is a wongame" do
    moves = [
      {"w", :good_guess},
      {"i", :good_guess},
      {"b", :good_guess},
      {"l", :good_guess},
      {"e", :won}
    ]

   game = Game.new_game("wibble")

    Enum.reduce(moves,game, fn({ guess, state }, new_game ) ->
      { new_game, _tally } = Game.make_move(new_game, guess)
      assert new_game.game_state == state
      new_game
    end)

    # for {guess, state} <- moves do
    #  game = Game.make_move(game, guess)
    #   assertgame.game_state == state
    # end

    # {game, _tally} = Game.make_move(game, "w")
    # assertgame.game_state == :good_guess
    # assertgame.turns_left == 7
    #
    # {game, _tally} = Game.make_move(game, "i")
    # assertgame.game_state == :good_guess
    # assertgame.turns_left == 7
    #
    # {game, _tally} = Game.make_move(game, "b")
    # assertgame.game_state == :good_guess
    # assertgame.turns_left == 7
    #
    # {game, _tally} = Game.make_move(game, "l")
    # assertgame.game_state == :good_guess
    # assertgame.turns_left == 7
    #
    # {game, _tally} = Game.make_move(game, "e")
    # assertgame.game_state == :won
    # assertgame.turns_left == 7
  end

  test "bad guess recognized" do
    game = Game.new_game("wibble")
    { game, _tally } = Game.make_move(game, "x")

    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "lostgame is recognized" do
    game = Game.new_game("w")

    { game, _tally } = Game.make_move(game, "a")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6

    { game, _tally } = Game.make_move(game, "b")
    assert game.game_state == :bad_guess
    assert game.turns_left == 5

    { game, _tally } = Game.make_move(game, "c")
    assert game.game_state == :bad_guess
    assert game.turns_left == 4

    { game, _tally } = Game.make_move(game, "d")
    assert game.game_state == :bad_guess
    assert game.turns_left == 3

    { game, _tally } = Game.make_move(game, "e")
    assert game.game_state == :bad_guess
    assert game.turns_left == 2

    { game, _tally } = Game.make_move(game, "f")
    assert game.game_state == :bad_guess
    assert game.turns_left == 1

    { game, _tally } = Game.make_move(game, "g")
    assert game.game_state == :lost
  end
end
