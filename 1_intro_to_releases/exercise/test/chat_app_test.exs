defmodule ChatAppTest do
  use ExUnit.Case
  doctest ChatApp

  test "greets the world" do
    assert ChatApp.hello() == :world
  end
end
