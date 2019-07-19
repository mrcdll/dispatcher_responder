defmodule FirmwareUpdaterWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: FirmwareUpdaterWeb

      import Plug.Conn
      import FirmwareUpdaterWeb.Gettext
      alias FirmwareUpdaterWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/firmware_updater_web/templates",
        namespace: FirmwareUpdaterWeb

      # Import convenience functions from controllers
      import Phoenix.LiveView, only: [live_render: 2, live_render: 3]
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import FirmwareUpdaterWeb.ErrorHelpers
      import FirmwareUpdaterWeb.Gettext
      alias FirmwareUpdaterWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Phoenix.LiveView.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import FirmwareUpdaterWeb.Gettext
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
