defmodule Pepe.Storage do
  use GenServer

  @memory_backend Application.get_env(:pepe, :storage)[:memory_backend]
  @persistent_backend Application.get_env(:pepe, :storage)[:persistent_backend]

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{env: Mix.env()}, name: __MODULE__)
  end

  def write(params) do
    GenServer.call(__MODULE__, {:write, params})
  end

  def overwrite(params) do
    GenServer.call(__MODULE__, {:overwrite, params})
  end

  def get_all() do
    @memory_backend.read()
  end

  @impl true
  def init(%{env: :test} = state) do
    # TODO find out a way to improve this
    # we can't interact with @memory_backend here during
    # tests because the mocks won't be configured yet, as this
    # callback is invoked during application startup and the tests
    # only run later
    {:ok, state}
  end

  @impl true
  def init(%{} = state) do
    send(self(), :init)
    {:ok, state}
  end

  @impl true
  def handle_info(:init, state) do
    {:ok, data} = @persistent_backend.read()
    :ok = @memory_backend.init(data)
    {:noreply, state}
  end

  @impl true
  def handle_call({:write, params}, _from, state) do
    :ok = @memory_backend.write(params)
    :ok = @persistent_backend.write(params)
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:overwrite, params}, _from, state) do
    :ok = @memory_backend.overwrite(params)
    :ok = @persistent_backend.overwrite(params)
    {:reply, :ok, state}
  end
end
