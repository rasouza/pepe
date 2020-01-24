defmodule PepeTest do
  use ExUnit.Case
  doctest Pepe

  test "greets the world" do
    assert Pepe.hello() == :world
  end
end
