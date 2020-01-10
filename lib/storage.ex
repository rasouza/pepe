defmodule Pepe.Storage do
  use GenServer

  @ets_table :storage_tree
  @ets_table_options [:set, :protected, :named_table, {:read_concurrency, true}]
  @file_name "data.json"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def put(key, params) do
    GenServer.call(__MODULE__, {:put, key, params})
  end

  def get(key) do
    data = :ets.lookup_element(@ets_table, :data, 2)
    data[key]
  end

  @impl true
  def init(_) do
    data = File.read(file_path()) |> decode_file()
    table = :ets.new(@ets_table, @ets_table_options)
    true = :ets.insert(table, {:data, data})
    {:ok, table}
  end

  @impl true
  def handle_call({:put, key, value}, _from, table) do
    data = get(key)
    new_data = Map.put(data, key, value)
    write_file(new_data)
    :ets.insert(table, {:data, new_data})
    {:reply, :ok, table}
  end

  defp file_path do
    {:ok, path} = File.cwd()
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

  defp write_file(data) do
    File.write(file_path(), Jason.encode!(data))
  end
end
