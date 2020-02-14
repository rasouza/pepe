defmodule Pepe.Storage.Backend do
  @callback init(Map.t()) :: :ok | {:error, term()}
  @callback write(Map.t()) :: :ok | {:error, term()}
  @callback overwrite(Map.t()) :: :ok | {:error, term()}
  @callback read() :: {:ok, Map.t()} | {:error, term()}
end
