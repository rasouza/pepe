defmodule Pepe.ReaderTest do
  use ExUnit.Case, async: true

  alias Pepe.Reader

  import Mox

  describe "get/2" do
    test "should return all configs when no path is given" do
      Pepe.Storage.Mock
      |> expect(:get_all, &fake_data/0)

      assert {:ok, %{"dummy" => 1, "dummy.br" => 2, "dummy.de" => 3}} ==
               Reader.get(nil, Pepe.Storage.Mock)
    end

    test "should search the data based on the given path" do
      Pepe.Storage.Mock
      |> expect(:get_all, &fake_data/0)

      assert {:ok, 1} == Reader.get("dummy", Pepe.Storage.Mock)
    end

    test "should process the path based on the dot notation" do
      Pepe.Storage.Mock
      |> expect(:get_all, &fake_data/0)

      assert {:ok, 2} == Reader.get("dummy.br.foo", Pepe.Storage.Mock)
    end

    test "should return {:error, :not_found} if given path is not found" do
      Pepe.Storage.Mock
      |> expect(:get_all, &fake_data/0)

      assert {:error, :not_found} == Reader.get("foo", Pepe.Storage.Mock)
    end
  end

  defp fake_data do
    {:ok,
     %{
       "dummy" => 1,
       "dummy.br" => 2,
       "dummy.de" => 3
     }}
  end
end
