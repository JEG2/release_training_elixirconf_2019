defmodule ExerciseTest do
  use ExUnit.Case
  doctest Exercise

  test "greets the world" do
    assert Exercise.hello() == :world
  end
end
