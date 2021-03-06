defmodule Pepe.Application do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(scheme: :http, plug: Pepe.Router, port: 8080),
      {Pepe.Storage.Impl, []}
    ]

    opts = [strategy: :one_for_one, name: Pepe.MainSupervisor]
    Supervisor.start_link(children, opts)
  end
end
