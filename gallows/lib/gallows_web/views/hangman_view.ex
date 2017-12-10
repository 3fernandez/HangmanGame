defmodule GallowsWeb.HangmanView do
  use GallowsWeb, :view

  def letters(letters) do
    letters |> Enum.join(" ")
  end
end
