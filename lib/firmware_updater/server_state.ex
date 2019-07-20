defmodule FirmwareUpdater.ServerState do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: DefaultServerState)
  end

  def update(pid, message) do
    GenServer.cast(pid, {:update, message})
  end

  def fetch(pid) do
    GenServer.call(pid, {:fetch})
  end

  # Server (callbacks)

  @spec init(any) :: {:ok, any}
  def init(empty_state) do
    {:ok, empty_state}
  end

  def handle_call({:fetch}, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:update, message}, state) do
    updated_state = [message | state]

    {:noreply, updated_state}
  end
end
