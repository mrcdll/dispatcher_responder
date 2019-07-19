defmodule FirmwareUpdaterWeb.PageController do
  use FirmwareUpdaterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
