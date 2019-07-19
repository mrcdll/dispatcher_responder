defmodule FirmwareUpdater.Application do
  use Application

  def start(_type, _args) do
    children = [
      FirmwareUpdaterWeb.Endpoint,
      %{
        id: FirmwareUpdater.Queue,
        start: {FirmwareUpdater.Queue, :start_link, [[]]}
      },
      FirmwareUpdater.GenStage.QueueFetcher,
      FirmwareUpdater.GenStage.KafkaDispatcherSupervsior
    ]

    Faker.start()

    opts = [strategy: :one_for_one, name: FirmwareUpdater.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    FirmwareUpdaterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
