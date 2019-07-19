defmodule FirmwareUpdater.Queue do
  use GenServer

  @spec start_link(maybe_improper_list) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(empty_queue) when is_list(empty_queue) do
    GenServer.start_link(__MODULE__, empty_queue, name: DefaultQueue)
  end

  @spec push(atom | pid | {atom, any} | {:via, atom, any}, any) :: :ok
  def push(pid, message) do
    IO.puts(pid)
    GenServer.cast(pid, {:push, message})
  end

  @spec fetch(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def fetch(pid) do
    GenServer.call(pid, :fetch)
  end

  # Server (callbacks)

  @spec init(any) :: {:ok, any}
  def init(queue) do
    {:ok, queue}
  end

  def handle_call(:fetch, _from, queue) do
    messages =
      MapSet.new(queue)
      |> Enum.take(5)

    {:reply, messages, queue}
  end

  def handle_cast({:push, message}, queue) do
    {:noreply, [message | queue]}
  end
end
