defmodule SupDemo do
  @moduledoc """
  Documentation for SupDemo.
  """
  alias SupDemo.GenServer.CompareSpawn

  @doc """
  Simple example that shows what's going on with a GenServer call if done
  like using a spawn to create a process.
  """
  def spawn_call() do
    CompareSpawn.spawn_call()
  end
end
