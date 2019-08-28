defmodule Exercise.JustOneProcess do
  use GenServer

  def start_link([]) do
    case GenServer.start_link(__MODULE__, nil, name: {:global, __MODULE__}) do
     {:error, {:already_started, _}} -> :ignore
     result -> result
    end
  end

  def init(nil) do
    IO.puts "Starting process #{inspect self()}…"
    :timer.send_interval(10_000, :tick)
    {:ok, nil}
  end

  def handle_info(:tick, nil) do
    IO.puts "Node: #{inspect Node.self()} Process #{inspect self()} is running…"
    {:noreply, nil}
  end
end
