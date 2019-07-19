defmodule FirmwareUpdater.DeviceHub do
  use GenServer
  @topic inspect(__MODULE__)

  @spec start_link :: :ignore | {:error, any} | {:ok, pid}
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: DefaultHub)
  end

  def subscribe(device_name) do
    Phoenix.PubSub.subscribe(FirmwareUpdater.PubSub, @topic <> "#{device_name}")
  end

  def messages_sent(pid, device_name) do
    GenServer.call(pid, {:messages_sent, device_name})
  end

  def add_message(pid, device_name) do
    GenServer.call(pid, {:add_message, device_name})
  end

  # Server (callbacks)

  @spec init(any) :: {:ok, any}
  def init(state) do
    {:ok, state}
  end

  def handle_call({:messages_sent, device_name}, _from, state) do
    initialized_state =
      case state[device_name] do
        nil -> Map.put_new(state, device_name, 0)
        _ -> state
      end

    {:reply, initialized_state[device_name], initialized_state}
  end

  def handle_call({:add_message, device_name}, _from, state) do
    updated_state = Map.update!(state, device_name, &(&1 + 1))

    {:reply, updated_state[device_name], updated_state}
  end
end
