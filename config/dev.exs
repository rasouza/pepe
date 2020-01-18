use Mix.Config

config :pepe, :storage,
  memory_backend: Pepe.Storage.Backend.Memory,
  persistent_backend: Pepe.Storage.Backend.Persistent
