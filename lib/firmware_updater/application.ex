defmodule FirmwareUpdater.Application do
  use Application

  @spec start(any, any) :: :ignore | {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      FirmwareUpdaterWeb.Endpoint,
      %{
        id: FirmwareUpdater.ServerState,
        start: {FirmwareUpdater.ServerState, :start_link, []}
      },
      %{
        id: FirmwareUpdater.Queue,
        start: {FirmwareUpdater.Queue, :start_link, [[]]}
      },
      %{
        id: FirmwareUpdater.DeviceHub,
        start: {FirmwareUpdater.DeviceHub, :start_link, []}
      },
      FirmwareUpdater.GenStage.QueueFetcher,
      FirmwareUpdater.GenStage.KafkaDispatcherSupervsior
    ]

    Faker.start()

    opts = [strategy: :one_for_one, name: FirmwareUpdater.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @spec config_change(any, any, any) :: :ok
  def config_change(changed, _new, removed) do
    FirmwareUpdaterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
