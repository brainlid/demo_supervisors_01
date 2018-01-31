# SupDemo

Demonstration project around Supervisors for meetup presentation.


## Comparison of `spawn` and `GenServer`

Spawn version of the "client" process execution.

```elixir
defmodule SupDemo.GenServer.CompareSpawn do

  def spawn_call() do
    server_pid = spawn(__MODULE__, :launch_server_process, [])
    Process.register(server_pid, __MODULE__)

    send(__MODULE__, {:do_work, self()})

    receive do
      {:work_done, answer} -> answer
    after
      5_000 ->
        {:error, "Timed out waiting!"}
    end
  end
end
```

GenServer version of the "client" process execution.

```elixir
defmodule SupDemo.GenServer.SimpleServer do

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, [name: __MODULE__])
  end

  def do_work() do
    GenServer.call(__MODULE__, :do_work)
  end
end
```

Spawn version of the "server" process execution.

```elixir
defmodule SupDemo.GenServer.CompareSpawn do

  def launch_server_process() do
    # like the GenServer.init callback
    simple_process_fun()
  end

  def simple_process_fun() do
    receive do
      {:do_work, sender} ->
        send(sender, {:work_done, 42})
    end
    simple_process_fun()
  end
end
```


GenServer version of the "server" process execution.

```elixir
defmodule SupDemo.GenServer.SimpleServer do
  use GenServer

  def init(initial_state) do
    # this is not needed in this example
    {:ok, initial_state}
  end

  def handle_call(:do_work, _from, state) do
    {:reply, 42, state}
  end
end
```
