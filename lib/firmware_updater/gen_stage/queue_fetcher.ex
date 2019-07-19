defmodule FirmwareUpdater.GenStage.QueueFetcher do
  use GenStage

  def start_link(args) do
    GenStage.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    {:producer, 0}
  end

  def handle_demand(consumer_demand, pending_demand) when consumer_demand > 0 do
    total_needed = consumer_demand + pending_demand
    messages = FirmwareUpdater.Queue.fetch(DefaultQueue)
    new_total_needed = total_needed - Enum.count(messages)

    if new_total_needed > 0 do
      poll_for_more_messages(2_000)
    end

    {:noreply, messages, new_total_needed}
  end

  def handle_info(:poll_for_more_messages, total_needed) do
    messages = FirmwareUpdater.Queue.fetch(DefaultQueue)
    new_total_needed = total_needed - Enum.count(messages)

    if new_total_needed > 0 do
      poll_for_more_messages(2_000)
    end

    {:noreply, messages, new_total_needed}
  end

  defp poll_for_more_messages(delay) do
    Process.send_after(self(), :poll_for_more_messages, delay)
  end
end
