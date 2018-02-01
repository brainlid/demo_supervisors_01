defmodule SupDemo.GenServer.SimpleWorker do
  @moduledoc """
  Simple Worker GenServer used in other examples.

  It is intended to be dynamically added and can be set to die abnormally
  or complete normally after a duration.

  Helps illustrate DynamicSupervision and restart settings.
  """
  use GenServer
  alias SupDemo.Utils

  ###
  ### Client
  ###

  def start_link(opts \\ []) do
    duration = Keyword.get(opts, :duration, 6_000)
    end_reason = Keyword.get(opts, :end_reason, :normal)
    initial_state = %{
      duration: duration,
      end_reason: end_reason
    }
    GenServer.start_link(__MODULE__, initial_state, [])
  end

  ###
  ### Server (callbacks)
  ###

  def init(initial_state) do
    Utils.color(:magenta)
    Utils.say("SimpleWorker started", delay: :short)
    Process.send_after(self(), :do_work, 1)
    {:ok, initial_state}
  end

  def handle_info(:do_work, %{duration: duration, end_reason: :normal} = state) do
    Process.sleep(duration)
    Utils.say("Completed pretend task of duration: #{inspect duration}")
    {:stop, :normal, state}
  end

  def handle_info(:do_work, %{duration: duration, end_reason: end_reason} = state) do
    Process.sleep(duration)
    Utils.say("Conclusion of task was not :normal! #{inspect end_reason}")
    {:stop, end_reason, state}
  end
  def handle_info(request, state) do
    super(request, state)
  end
end
