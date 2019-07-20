defmodule FirmwareUpdater.GenStage.KafkaDispatcher do
  @spec start_link(any) :: {:ok, pid}
  def start_link(message) do
    Task.start_link(fn ->
      FirmwareUpdater.ServerState.update(DefaultServerState, %{
        pid: self(),
        message: message,
        time: NaiveDateTime.utc_now()
      })

      FirmwareUpdater.DeviceHub.notify_dispatch()
    end)
  end
end
