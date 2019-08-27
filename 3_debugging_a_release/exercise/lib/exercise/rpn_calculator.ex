defmodule Exercise.RPNCalculator do
  use GenServer

  def start_link(args) do
    GenServer.start_link(
      __MODULE__,
      Keyword.get(args, :initial_stack, []),
      Keyword.get(args, :options, [])
    )
  end

  def push(calculator \\ __MODULE__, num) when is_number(num) do
    GenServer.call(calculator, {:push, num})
  end

  def operator(calculator \\ __MODULE__, op) when op in ~w[+ - * /]a do
    GenServer.call(calculator, {:operator, op})
  end

  def init(initial_stack) do
    {:ok, initial_stack}
  end

  def handle_call({:push, num}, _from, stack) when length(stack) <= 100 do
    {:reply, num, [num | stack]}
  end

  def handle_call({:operator, op}, _from, [r, l | stack]) do
    result = apply(Kernel, op, [l, r])
    {:reply, result, [result | stack]}
  end
end
