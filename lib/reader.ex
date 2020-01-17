defmodule Pepe.Reader do
  require Logger

  alias Pepe.Storage

  @last_item -1

  def get(%{"path" => path}) do
    data = Storage.get_all()
    find(data, path)
  end

  def get(%{}) do
    {:ok, Storage.get_all()}
  end

  defp find(_data, ""), do: {:error, :not_found}

  defp find(data, path) when is_binary(path) do
    case Map.get(data, path) do
      nil ->
        find(data, path |> String.split(".") |> List.delete_at(@last_item) |> Enum.join("."))

      value ->
        {:ok, value}
    end
  end
end
