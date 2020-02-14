defmodule Pepe.Storage.Test do
  use ExUnit.Case, async: true

  alias Pepe.Storage.Impl, as: StorageImpl

  import Mox

  setup :verify_on_exit!

  test "Storage should initialize its memory_backend with the contents of its persistent_backend upon init" do
    Pepe.Storage.Backend.Persistent.Mock
    |> expect(:read, fn -> {:ok, %{foo: :bar}} end)

    Pepe.Storage.Backend.Memory.Mock
    |> expect(:init, fn %{foo: :bar} -> :ok end)

    {:noreply, _} = StorageImpl.handle_info(:init, %{})
  end

  test "Storage should read the contents from the memory_backend and not from persistent_backend" do
    Pepe.Storage.Backend.Persistent.Mock
    |> expect(:read, 0, fn -> {:ok, %{from: :persistent}} end)

    Pepe.Storage.Backend.Memory.Mock
    |> expect(:read, fn -> {:ok, %{from: :memory}} end)

    {:ok, %{from: :memory}} = StorageImpl.get_all()
  end

  test "Storage should write to both backends" do
    Pepe.Storage.Backend.Memory.Mock
    |> expect(:write, fn %{foo: :bar} -> :ok end)

    Pepe.Storage.Backend.Persistent.Mock
    |> expect(:write, fn %{foo: :bar} -> :ok end)

    {:reply, :ok, _} = StorageImpl.handle_call({:write, %{foo: :bar}}, self(), %{})
  end

  test "Storage should overwrite to both backends" do
    Pepe.Storage.Backend.Memory.Mock
    |> expect(:overwrite, fn %{foo: :bar} -> :ok end)

    Pepe.Storage.Backend.Persistent.Mock
    |> expect(:overwrite, fn %{foo: :bar} -> :ok end)

    {:reply, :ok, _} = StorageImpl.handle_call({:overwrite, %{foo: :bar}}, self(), %{})
  end
end
