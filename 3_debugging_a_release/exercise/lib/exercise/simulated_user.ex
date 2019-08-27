defmodule Exercise.SimulatedUser do
  use GenServer
  alias Exercise.RPNCalculator

  def start_link(args) do
    GenServer.start_link(__MODULE__, nil, Keyword.get(args, :options, []))
  end

  def init(nil) do
    RPNCalculator.push(1)
    RPNCalculator.push(1)
    :timer.send_interval(500, :tick)
    {:ok, nil}
  end

  def handle_info(:tick, nil) do
    if :rand.uniform(4) < 4 do
      RPNCalculator.push(:rand.uniform(11) - 1)
    else
      RPNCalculator.operator(Enum.random(~w[+ - * /]a))
    end
    {:noreply, nil}
  end
end
