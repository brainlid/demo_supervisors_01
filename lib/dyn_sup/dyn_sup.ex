defmodule SupDemo.DynSup do
  # Automatically defines child_spec/1
  use DynamicSupervisor
  alias Supervisor.Spec
  alias SupDemo.GenServer.SimpleWorker

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def start_child(args) do
    # TODO: Experiement with the different restart options. What fits your need?
    # spec = Spec.worker(SimpleWorker, [args], [restart: :temporary])
    spec = Spec.worker(SimpleWorker, [args], [restart: :transient])
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
