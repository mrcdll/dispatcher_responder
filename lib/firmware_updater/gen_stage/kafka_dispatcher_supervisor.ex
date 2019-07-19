defmodule FirmwareUpdater.GenStage.KafkaDispatcherSupervsior do
  use ConsumerSupervisor

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(args) do
    ConsumerSupervisor.start_link(__MODULE__, args)
  end

  def init(_arg) do
    children = [
      %{
        id: FirmwareUpdater.GenStage.KafkaDispatcher,
        start: {FirmwareUpdater.GenStage.KafkaDispatcher, :start_link, []},
        restart: :transient
      }
    ]

    opts = [
      strategy: :one_for_one,
      subscribe_to: [
        {FirmwareUpdater.GenStage.QueueFetcher, max_demand: 5}
      ]
    ]

    ConsumerSupervisor.init(children, opts)
  end
end
