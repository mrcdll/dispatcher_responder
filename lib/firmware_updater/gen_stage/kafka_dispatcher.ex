defmodule FirmwareUpdater.GenStage.KafkaDispatcher do
  @spec start_link(any) :: {:ok, pid}
  def start_link(message) do
    Task.start_link(fn ->
      IO.puts(
        "Process #{self() |> inspect()}, dispatched #{message.device_name}'s #{message.payload}'"
      )
    end)
  end
end
