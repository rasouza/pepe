defmodule Pepe.Controller do
  require Logger

  def get(path, params) do
    case Pepe.Reader.get(path, params) do
      {:error, :not_found} ->
        {404, "Not Found"}

      {:ok, value} when is_binary(value) ->
        {200, value}

      {:ok, value} ->
        {200, "#{inspect(value)}"}
    end
  end

  def post(path, params) do
    Pepe.Storage.put(path, params)
    {201, "Created"}
  end
end
