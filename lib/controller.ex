defmodule Pepe.Controller do
  require Logger

  @reader Pepe.Reader
  @storage Pepe.Storage.Impl

  def get(params) do
    case @reader.get(params["path"], @storage) do
      {:error, :not_found} ->
        {404, "Not Found"}

      {:ok, %{} = value} ->
        {200, value}

      {:ok, value} ->
        {200, "#{inspect(value)}"}
    end
  end

  def post(params) do
    @storage.overwrite(params)
    {201, "Created"}
  end

  def patch(params) do
    @storage.write(params)
    {204, ""}
  end
end
