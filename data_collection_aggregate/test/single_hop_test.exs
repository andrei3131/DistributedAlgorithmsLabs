defmodule SingleHopTest do
  use ExUnit.Case
  doctest SingleHop

  test "greets the world" do
    assert SingleHop.hello() == :world
  end
end
