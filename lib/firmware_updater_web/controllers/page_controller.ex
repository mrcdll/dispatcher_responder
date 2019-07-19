defmodule FirmwareUpdaterWeb.PageController do
  use FirmwareUpdaterWeb, :controller
  alias Phoenix.LiveView

  def index(conn, params) do
    [device_name | _params] = params["path"]

    LiveView.Controller.live_render(conn, FirmwareUpdaterWeb.ControlPanelView,
      session: %{device_name: device_name}
    )
  end
end
