defmodule FirmwareUpdaterWeb.Router do
  use FirmwareUpdaterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FirmwareUpdaterWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
