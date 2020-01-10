import Config

config :pepe, :storage,
  memory_backend: Pepe.Storage.Backend.Memory.Mock,
  persistent_backend: Pepe.Storage.Backend.Persistent.Mock
