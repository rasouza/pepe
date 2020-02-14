defmodule Pepe.Reader do
  require Logger

  @last_item -1

  @spec get(String.t(), atom()) :: {:ok | :error, String.t() | :not_found}
  def get(nil, storage) do
    Logger.info("Getting all configs")
    storage.get_all()
  end

  def get(path, storage) do
    {:ok, data} = storage.get_all()
    find(data, path)
  end

  defp find(_data, "") do
    Logger.warn("Not found")
    {:error, :not_found}
  end

  defp find(data, path) when is_binary(path) do
    Logger.info("Looking up config for #{path}")

    case Map.get(data, path) do
      nil ->
        find(data, path |> String.split(".") |> List.delete_at(@last_item) |> Enum.join("."))

      value ->
        Logger.info("Found: #{inspect(value)}")
        {:ok, value}
    end
  end
end
