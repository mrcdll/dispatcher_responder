defmodule FirmwareUpdaterWeb.PageController do
  use FirmwareUpdaterWeb, :controller
  alias Phoenix.LiveView

  def index(conn, params) do
    render_page(conn, params["path"])
  end

  def render_page(conn, []) do
    text(conn, "Specify a device identifier (e.g. localhost.com:4000/marco)")
  end

  def render_page(conn, path) do
    [device_name | _params] = path

    LiveView.Controller.live_render(conn, FirmwareUpdaterWeb.ControlPanelView,
      session: %{device_name: device_name}
    )
  end
end
