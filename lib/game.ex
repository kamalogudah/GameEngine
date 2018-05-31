defmodule IslandsEngine.Game do
  use GenServer

  def handle_info(:first, state) do
    IO.puts "This message has been handled by handle_info/2, matching on :first."
    {:noreply, state}
  end

  def handle_call(:demo, _from, state) do
    {:reply, state, state}
  end

  def call_demo(game) do
    GenServer.call(game, :demo)
  end
end
