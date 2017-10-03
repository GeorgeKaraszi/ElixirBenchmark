defmodule ThreadsVsProcessesTest do
  use ExUnit.Case
  doctest ThreadsVsProcesses

  test "greets the world" do
    assert ThreadsVsProcesses.hello() == :world
  end
end
