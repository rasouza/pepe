import Config

config :logger, :console, metadata: :all

config :pepe, :storage,
  memory_backend: Pepe.Storage.Backend.Memory,
  persistent_backend: Pepe.Storage.Backend.Persistent

import_config "#{Mix.env()}.exs"
