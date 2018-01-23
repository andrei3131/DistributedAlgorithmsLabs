defmodule NclientsServerTest do
  use ExUnit.Case
  doctest NclientsServer

  test "greets the world" do
    assert NclientsServer.hello() == :world
  end
end
