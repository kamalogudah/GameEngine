defmodule IslandsEngine.Game do
  defstruct player1: :none, player2: :none
  alias IslandsEngine.{Coordinate, Game, Player}
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

  def handle_call({:add_player, name}, _from, state) do
    Player.set_name(state.player2, name)
    {:reply, :ok, state}
  end

  def handle_call({:guess, player, coordinate}, _from, state) do
    opponent = opponent(state, player)
    opponent_board = Player.get_board(opponent)
    response = Player.guess_coordinate(opponent_board, coordinate)
    |> forest_check(opponent, coordinate)

  end

  def call_demo(game) do
    GenServer.call(game, :demo)
  end

  def add_player(pid, name) when name != nil do
    GenServer.call(pid, {:add_player, name})
  end

  def set_island_coordinates(pid, player, island, coordinates)
    when is_atom player and is_atom island do
    GenServer.call(pid, {:set_island_coordinates, player, island, coordinates})
  end

  def handle_call({:set_island_coordinates, player, island, coordinates}, _from, state) do
    state
    |> Map.get(player)
    |> Player.set_island_coordinates(island, coordinates)
    {:reply, :ok, state}
  end

  def guess_coordinate(pid, player, coordinate)
    when is_atom player and is_atom coordinate do
      GenServer.call(pid, {:guess, player, coordinate})
  end

  defp opponent(state, :player1) do
    state.player2
  end

  defp opponent(state, _player2) do
    state.player1
  end

  defp forest_check(:miss, _opponent, _coordinate) do
    {:miss, :none}
  end

  defp forest_check(:hit, opponent, coordinate) do
    island_key = Player.forested_island(opponent, coordinate)
    {:hit, island_key}
  end
end
