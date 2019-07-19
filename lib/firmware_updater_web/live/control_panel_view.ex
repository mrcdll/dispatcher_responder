defmodule FirmwareUpdaterWeb.ControlPanelView do
  use Phoenix.LiveView

  def render(assigns) do
    FirmwareUpdaterWeb.PageView.render("control_panel.html", assigns)
  end

  def mount(session, socket) do
    {:ok, assign(socket, device_name: session.device_name)}
  end

  def handle_event("send_random_message", _value, socket) do
    message = %{device_name: socket.assigns.device_name, payload: Faker.StarWars.character()}
    FirmwareUpdater.Queue.push(DefaultQueue, message)

    {:noreply, assign(socket, %{})}
  end
end
