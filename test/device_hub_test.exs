defmodule DeviceHubtest do
  use ExUnit.Case

  setup do
    FirmwareUpdater.DeviceHub.messages_sent(DefaultHub, "test_device")
    :ok
  end

  test "add message to counter" do
    assert 1 == FirmwareUpdater.DeviceHub.add_message(DefaultHub, "test_device")
  end

  test "return the number of messages" do
    assert 1 == FirmwareUpdater.DeviceHub.messages_sent(DefaultHub, "test_device")
  end

  test "subscribe device" do
    assert :ok == FirmwareUpdater.DeviceHub.subscribe_client("test_device")
  end

  test "subscribe to server" do
    assert :ok == FirmwareUpdater.DeviceHub.subscribe_to_server()
  end
end
