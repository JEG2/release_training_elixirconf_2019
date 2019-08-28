### Resources

* https://metasyntactic.info/distributing-phoenix-part-2/
* https://learn-elixir.dev/uses-of-elixir-task-module
* https://sorentwo.com/2019/07/18/oban-recipes-part-1-unique-jobs.html

### Solution Part 3

```Elixir
defmodule AGlobalProcess do
  use GenServer

  def start_link(args) do
    IO.puts "Attempting a start on #{inspect Node.self()}…"
    case GenServer.start_link(__MODULE__, args, name: {:global, __MODULE__}) do
      {:error, {:already_started, _pid}} ->
        IO.puts "Ignored."
        :ignore

      result ->
        result
    end
  end

  def init(_args) do
    IO.puts "Starting #{inspect self()}…"
    {:ok, %{ }}
  end
end

defmodule NodeMonitor do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    :net_kernel.monitor_nodes(true)
    {:ok, %{ }}
  end

  def handle_info({:nodeup, _node}, %{ } = state) do
    show_processes()
    {:noreply, state}
  end

  def handle_info({:nodedown, _node}, %{ } = state) do
    show_processes()
    Supervisor.restart_child(MySupervisor, AGlobalProcess)
    show_processes()
    {:noreply, state}
  end

  defp show_processes do
    Supervisor.which_children(MySupervisor)
    |> IO.inspect()
  end
end

{:ok, _supervisor} = Supervisor.start_link(
  [
    AGlobalProcess,
    NodeMonitor
  ],
  strategy: :one_for_one,
  name: MySupervisor
)
Supervisor.which_children(MySupervisor)
|> IO.inspect()

case Node.self() |> to_string() |> String.split("@") do
  ["one", _machine] ->
    Process.sleep(:infinity)

  ["two", machine] ->
    true = Node.connect(:"one@#{machine}")
    Process.sleep(:infinity)

  _other ->
    IO.puts "Please use `--sname one` and `--sname two`"
end
```

## Debugging

* Context:  how do I know what's going wrong in my app and where it is?  How do I debug an async system?
* Takeaway:  the tools to answer questions about a running cluster

### Tools

Topology:

* `Node.list/0`
* `Process.registered/0`
* `:global.registered_names/0`
* `Supervisor.which_children/1`
* `Process.whereis/1`
* `:global.whereis_names/1`
* `:observer`
* `:observer_cli`

Process metrics:

* `Process.info/2`
* `:sys.get_state/1`
* `Process.alive?/1`
* `Process.monitor/1`
* `:observer`
* `:observer_cli`

Messages:

* `:dbg`

Functions:

* `some_module.__info__(:functions)`
* `:dbg`

### Resources

* https://zorbash.com/post/debugging-elixir-applications/
* https://github.com/zhongwencool/observer_cli
* https://github.com/ferd/recon
* http://erlang.org/doc/man/erlang.html#trace-3
* http://erlang.org/doc/man/dbg.html
* https://stackoverflow.com/questions/1954894/using-trace-and-dbg-in-erlang

### Solution Part 4

```Elixir
# starting the release
MIX_ENV=prod mix release
_build/prod/rel/exercise/bin/exercise start

# connecting to it
_build/prod/rel/exercise/bin/exercise remote



# find processes
Process.registered
Supervisor.which_children(Exercise.Supervisor)

# find messages
device = Process.group_leader
:dbg.tracer(:process, {fn msg, _state -> IO.puts(device, inspect(msg)) end, :initial_state})
:dbg.p(Exercise.RPNCalculator, [:r])
:dbg.stop_clear

# find bugs
defmodule Crash do
  def show do
    ref = Process.monitor(Exercise.RPNCalculator)
    receive do
      {:DOWN, ^ref, :process, _pid, :noproc} -> 
        :ok
        
      {:DOWN, ^ref, :process, _pid, reason} -> 
        IO.inspect(reason) 
        show()
    end
  end
end
Crash.show

# show functions called
device = Process.group_leader
:dbg.tracer(:process, {fn msg, _state -> IO.puts(device, inspect(msg)) end, :initial_state})
:dbg.p(Exercise.SimulatedUser, [:call])
:dbg.tp(Exercise.RPNCalculator, :_, [])
:dbg.stop_clear
```
