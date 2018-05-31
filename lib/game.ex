defmodule IslandsEngine.Game do
  defstruct player1: :none, player2: :none
  alias IslandsEngine.{Game, Player}
  use GenServer

  def start_link(name) when not is_nil name do
    GenServer.start_link(__MODULE__, name)
  end

  def init(name) do
    {:ok, player1} = Player.start_link(name)
    {:ok, player2} = Player.start_link()
    {:ok, %Game{player1: player1, player2: player2}}
  end

  def handle_call(:demo, _from, state) do
    {:reply, state, state}
  end

  def call_demo(game) do
    GenServer.call(game, :demo)
  end

end
