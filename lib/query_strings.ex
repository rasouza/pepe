defmodule Pepe.QueryString do
  @spec transform(String.t()) :: [{String.t(), String.t()}, ...]
  def transform(query_string) when is_binary(query_string) do
    String.split(query_string, "&")
    |> Enum.map(fn key_value ->
      String.split(key_value, "=")
    end)
    |> flatten([])
  end

  defp flatten([], acc), do: acc

  defp flatten([[a, b] | tail], acc) when a !== "" and b !== "" do
    flatten(tail, acc ++ [{a, b}])
  end

  defp flatten([_head | tail], acc) do
    flatten(tail, acc)
  end
end
