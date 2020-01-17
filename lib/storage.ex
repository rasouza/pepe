defmodule Pepe.Storage do
  use GenServer

  @ets_table :storage_tree
  @ets_table_options [:set, :protected, :named_table, {:read_concurrency, true}]
  @file_name "data.json"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def write(params) do
    GenServer.call(__MODULE__, {:write, params})
  end

  def overwrite(params) do
    GenServer.call(__MODULE__, {:overwrite, params})
  end

  def get_all() do
    :ets.lookup_element(@ets_table, :content, 2)
  end

  @impl true
  def init(_) do
    data = File.read(file_path()) |> decode_file()
    table = :ets.new(@ets_table, @ets_table_options)
    true = :ets.insert(table, content: data)
    {:ok, table}
  end

  @impl true
  def handle_call({:write, params}, _from, state) do
    data = get_all()
    true = :ets.insert(@ets_table, content: Map.merge(data, params))
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:overwrite, params}, _from, state) do
    true = :ets.insert(@ets_table, content: params)
    {:reply, :ok, state}
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
end
