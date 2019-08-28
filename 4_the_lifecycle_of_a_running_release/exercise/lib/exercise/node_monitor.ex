defmodule Exercise.NodeMonitor do
 use GenServer
 
 def start_link([]) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
 end
 
 def init(nil) do
    :net_kernel.monitor_nodes(true)
    {:ok, nil}
 end
 
 def handle_info(msg, nil) do
    case msg do
    {:nodeup, node} -> :ok
    {:nodedown, node} -> Supervisor.restart_child(Exercise.Supervisor, Exercise.JustOneProcess)
    _ -> IO.puts("Unexpected msg")
    end
    {:noreply, nil}
 end
 
 
end
