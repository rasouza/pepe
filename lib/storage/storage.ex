defmodule Pepe.Storage do
  @callback write(%{}) :: {:ok | :error, term()}
  @callback overwrite(%{}) :: {:ok | :error, term()}
  @callback get_all() :: {:ok | :error, %{} | term()}
end
