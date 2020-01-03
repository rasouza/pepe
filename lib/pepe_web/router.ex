defmodule PepeWeb.Router do
  use PepeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PepeWeb do
    pipe_through :api
  end
end
