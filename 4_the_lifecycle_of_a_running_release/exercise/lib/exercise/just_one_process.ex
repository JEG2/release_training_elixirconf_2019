defmodule Exercise.JustOneProcess do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(nil) do
    IO.puts "Starting process #{inspect self()}…"
    :timer.send_interval(3_000, :tick)
    {:ok, nil}
  end

  def handle_info(:tick, nil) do
    IO.puts "Process #{inspect self()} is running…"
    {:noreply, nil}
  end
end
