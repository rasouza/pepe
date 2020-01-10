defmodule Pepe.Reader do
  require Logger

  alias Pepe.Storage

  @value "value"

  def get(key, options) do
    case Storage.get(key) do
      nil ->
        {:error, :not_found}

      data ->
        {:ok, find(data, options)}
    end
  end

  defp find(data, []), do: do_find(data, [])

  defp find(data, options) when is_list(options) do
    Logger.debug("Looking for #{inspect(options)} inside #{inspect(data)}")

    transformed =
      Enum.map(options, fn {key, value} ->
        [key, value]
      end)
      |> List.flatten()

    do_find(data, transformed)
  end

  defp do_find(data, []), do: Map.get(data, @value, :not_found)

  defp do_find(data, [head | tail]) do
    Logger.debug("Searching #{inspect(head)} inside #{inspect(data)}")

    case Map.get(data, head) do
      nil ->
        Map.get(data, @value, :not_found)

      %{} = value ->
        case do_find(value, tail) do
          :not_found ->
            Map.get(data, @value, :not_found)

          result ->
            result
        end
    end
  end
end
