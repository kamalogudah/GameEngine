defmodule IslandsEngine.Coordinate do
  defstruct in_island: :none, guessed?: false
  alias IslandsEngine.Coordinate

  def start_link() do
    Agent.start_link(fn -> %Coordinate{} end)
  end
end