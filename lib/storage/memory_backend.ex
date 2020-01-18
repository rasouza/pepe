defmodule Pepe.Storage.Backend.Memory do
  alias Pepe.Storage.Backend

  @behaviour Backend

  @ets_table :storage_tree
  @ets_table_options [:set, :protected, :named_table, {:read_concurrency, true}]

  @impl true
  def init(%{} = map) do
    :ets.new(@ets_table, @ets_table_options)
    write(map)
  end

  @impl true
  def write(%{} = map) do
    true = :ets.insert(@ets_table, map |> Map.to_list())
    :ok
  end

  @impl true
  def overwrite(%{} = map) do
    true = :ets.delete_all_objects(@ets_table)
    write(map)
  end

  @impl true
  def read() do
    {:ok, :ets.tab2list(@ets_table) |> Map.new()}
  end
end
