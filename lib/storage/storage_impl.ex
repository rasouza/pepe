defmodule Pepe.Storage.Impl do
  @behaviour Pepe.Storage

  use GenServer

  require Logger

  @memory_backend Application.get_env(:pepe, :storage)[:memory_backend]
  @persistent_backend Application.get_env(:pepe, :storage)[:persistent_backend]

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def write(params) do
    GenServer.call(__MODULE__, {:write, params})
  end

  @impl true
  def overwrite(params) do
    GenServer.call(__MODULE__, {:overwrite, params})
  end

  @impl true
  def get_all() do
    @memory_backend.read()
  end

  @impl true
  def init(%{} = state) do
    send(self(), :init)
    {:ok, state}
  end

  @impl true
  def handle_info(:init, state) do
    Logger.info("Loading memory storage")
    {:ok, data} = @persistent_backend.read()
    Logger.debug("Loaded #{inspect(data)}")
    :ok = @memory_backend.init(data)
    {:noreply, state}
  end

  @impl true
  def handle_call({:write, params}, _from, state) do
    Logger.debug("Adding #{inspect(params)} to configs")
    :ok = @memory_backend.write(params)
    :ok = @persistent_backend.write(params)
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:overwrite, params}, _from, state) do
    Logger.debug("Overwriting configs with #{inspect(params)}")
    :ok = @memory_backend.overwrite(params)
    :ok = @persistent_backend.overwrite(params)
    {:reply, :ok, state}
  end
end
