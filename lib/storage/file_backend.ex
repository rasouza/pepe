defmodule Pepe.Storage.Backend.Persistent do
  @behaviour Pepe.Storage.Backend

  @file_name "pepe_data.json"

  @impl true
  def init(_), do: :ok

  @impl true
  def read() do
    {:ok, File.read(file_path()) |> decode_file()}
  end

  @impl true
  def write(%{} = map) do
    {:ok, file_content} = read()
    overwrite(Map.merge(file_content, map))
  end

  @impl true
  def overwrite(%{} = map) do
    File.write(file_path(), Jason.encode!(map))
  end

  defp file_path do
    path = System.tmp_dir!()
    "#{path}/#{@file_name}"
  end

  defp decode_file({:ok, data}) do
    case Jason.decode(data) do
      {:ok, state} ->
        state

      {:error, _} ->
        %{}
    end
  end

  defp decode_file(_) do
    %{}
  end
end
