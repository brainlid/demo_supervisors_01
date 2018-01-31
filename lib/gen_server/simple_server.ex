defmodule SupDemo.GenServer.SimpleServer do
  @moduledoc """
  Simple GenServer to use for simple supervisor examples.
  This GenServer just outputs that it is running on a regular interval.
  """
  use GenServer
  alias SupDemo.Utils

  ###
  ### Client
  ###

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, [name: __MODULE__])
  end

  def do_work() do
    Utils.say("Requesting work to be done", delay: :short)
    answer = GenServer.call(__MODULE__, :do_work)
    Utils.say("Got the answer! #{inspect answer}", delay: :short)
    answer
  end

  ###
  ### Server (callbacks)
  ###

  def init(initial_state) do
    Utils.color(:blue)
    Utils.say("Server process started", delay: :short)
    schedule_something_to_say()
    {:ok, initial_state}
  end

  def handle_call(:do_work, _from, state) do
    Utils.say("Doing work")
    {:reply, 42, state}
  end
  def handle_call(request, _from, state) do
    Utils.say("Received 'call' request: #{inspect request}")
    answer = {:ok, 42}
    {:reply, answer, state}
  end
  # def handle_call(request, from, state) do
  #   # Call the default implementation from GenServer
  #   super(request, from, state)
  # end

  def handle_cast(request, state) do
    Utils.say("Received 'cast' request: #{inspect request}")
    {:noreply, state}
  end
  # def handle_cast(request, state) do
  #   super(request, state)
  # end

  def handle_info(:say_something, state) do
    schedule_something_to_say()
    Utils.say("I'm still here")
    {:noreply, state}
  end
  def handle_info(request, state) do
    super(request, state)
  end

  defp schedule_something_to_say() do
    Process.send_after(self(), :say_something, 3_000)
  end
end
