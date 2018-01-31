defmodule SupDemo.GenServer.CompareSpawn do
  @moduledoc """
  Code that shows the comparison of a `spawn` call to using a `GenServer`.
  """
  alias SupDemo.Utils

  @doc """
  Show the equivalent of a GenServer.call when using a spawned process.
  """
  def spawn_call() do
    Utils.color(:grey)

    server_pid = spawn(__MODULE__, :launch_server_process, [])
    Process.register(server_pid, __MODULE__)

    Utils.say("Requesting work to be done", delay: :short)
    send(__MODULE__, {:do_work, self()})

    Utils.say("Waiting for work results", delay: :short)
    receive do
      {:work_done, answer} ->
        Utils.say("Got the answer! #{inspect answer}", delay: :short)
        answer
    after
      5_000 ->
        message = "Timed out waiting!"
        Utils.say(message)
        {:error, message}
    end
  end

  @doc """
  Function that represents what the `GenServer.init` callback does.
  """
  def launch_server_process() do
    Utils.color(:blue)
    Utils.say("Server process started", delay: :short)
    # like the GenServer.init callback
    simple_process_fun()
  end

  @doc """
  Simple function to be run by a process to demonstrate the GenServer side of
  a `call`.
  """
  def simple_process_fun() do
    receive do
      {:do_work, sender} ->
        Utils.say("Doing work")
        send(sender, {:work_done, 42})
    end
    simple_process_fun()
  end

end
