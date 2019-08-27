defmodule ChatApp.Server do

  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  @impl true
  def init(messages) do
    {:ok, messages}
  end

  @impl true
  def handle_call(:last_message, _from, [last | _rest] = messages) do
    {:reply, last, messages}
  end
  def handle_call(:last_message, _from, [] = messages) do
    {:reply, "messages are empty", messages}
  end

  @impl true
  def handle_call(:motd, _from, _messages) do
    ## TODO: read the motd text file
  end

  @impl true
  def handle_cast({:send, message}, messages) do
    IO.puts "message: #{message} added"
    {:noreply, [message | messages]}
  end

  def push(message) do
    GenServer.cast(__MODULE__, {:send, message})
  end

  def last_message do
    GenServer.call(__MODULE__, :last_message)
  end
end
