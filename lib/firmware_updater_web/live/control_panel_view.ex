defmodule FirmwareUpdaterWeb.ControlPanelView do
  use Phoenix.LiveView
  alias FirmwareUpdater.DeviceHub

  def render(assigns) do
    FirmwareUpdaterWeb.PageView.render("control_panel.html", assigns)
  end

  def mount(session, socket) do
    device_name = session.device_name

    if connected?(socket) do
      DeviceHub.subscribe_to_server()
    end

    {:ok,
     assign(socket, %{
       device_name: device_name,
       messages_sent: DeviceHub.messages_sent(DefaultHub, device_name),
       server_state: FirmwareUpdater.ServerState.fetch(DefaultServerState),
       firmware_updates: []
     })}
  end

  @spec handle_event(<<_::152>>, any, Phoenix.LiveView.Socket.t()) :: {:noreply, any}
  def handle_event("send_random_message", _value, socket) do
    message = %{device_name: socket.assigns.device_name, payload: Faker.Food.dish()}

    FirmwareUpdater.Queue.push(DefaultQueue, message)
    messages_sent = DeviceHub.add_message(DefaultHub, socket.assigns.device_name)
    {:noreply, assign(socket, %{messages_sent: messages_sent})}
  end

  def handle_event("update_device", _value, socket) do
    message = %{device_name: socket.assigns.device_name, payload: Faker.Food.dish()}

    FirmwareUpdater.Queue.push(DefaultQueue, message)
    messages_sent = DeviceHub.add_message(DefaultHub, socket.assigns.device_name)
    {:noreply, assign(socket, %{messages_sent: messages_sent})}
  end

  def handle_event("firmware_update", _value, socket) do
    DeviceHub.notify_firmware_update()
    {:noreply, assign(socket, %{})}
  end

  def handle_info({FirmwareUpdater.DeviceHub, :dispatched}, socket) do
    server_state = FirmwareUpdater.ServerState.fetch(DefaultServerState)
    {:noreply, assign(socket, server_state: server_state)}
  end

  def handle_info({FirmwareUpdater.DeviceHub, :firmware_update, update}, socket) do
    firmware_updates = [update | socket.assigns.firmware_updates]
    {:noreply, assign(socket, firmware_updates: firmware_updates)}
  end
end
