defmodule HotCakesTest do
  use ExUnit.Case
  doctest HotCakes

  test "greets the world" do
    assert HotCakes.hello() == :world
  end
end
