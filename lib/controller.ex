defmodule Pepe.Controller do
  require Logger

  def get(params) do
    case Pepe.Reader.get(params) do
      {:error, :not_found} ->
        {404, "Not Found"}

      {:ok, %{} = value} ->
        {200, value}

      {:ok, value} ->
        {200, "#{inspect(value)}"}
    end
  end

  def post(params) do
    Pepe.Storage.overwrite(params)
    {201, "Created"}
  end

  def patch(params) do
    Pepe.Storage.write(params)
    {204, ""}
  end
end
