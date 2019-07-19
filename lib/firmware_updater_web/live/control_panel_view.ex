defmodule FirmwareUpdaterWeb.ControlPanelView do
  use Phoenix.LiveView

  def render(assigns) do
    FirmwareUpdaterWeb.PageView.render("control_panel.html", assigns)
  end

  def mount(session, socket) do
    device_name = session.device_name

    if connected?(socket), do: FirmwareUpdater.DeviceHub.subscribe(device_name)
    messages_sent = FirmwareUpdater.DeviceHub.messages_sent(DefaultHub, device_name)

    {:ok, assign(socket, %{device_name: device_name, messages_sent: messages_sent})}
  end

  @spec handle_event(<<_::152>>, any, Phoenix.LiveView.Socket.t()) :: {:noreply, any}
  def handle_event("send_random_message", _value, socket) do
    message = %{device_name: socket.assigns.device_name, payload: Faker.Food.dish()}

    FirmwareUpdater.Queue.push(DefaultQueue, message)
    messages_sent = FirmwareUpdater.DeviceHub.add_message(DefaultHub, socket.assigns.device_name)
    {:noreply, assign(socket, %{messages_sent: messages_sent})}
  end
end
