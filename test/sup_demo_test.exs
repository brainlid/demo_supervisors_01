defmodule SupDemoTest do
  use ExUnit.Case
  doctest SupDemo

  test "greets the world" do
    assert SupDemo.hello() == :world
  end
end
