defmodule Warehouse.Manager do
  use DynamicSupervisor

  require Logger

  alias Warehouse.Worker

  def start_link(_arg) do
    Logger.debug fn -> "Starting Warehouse Manager" end
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # Start a Worker process and add it to supervision
  def add_worker(worker_args) do
    Logger.debug fn -> "Starting Warehouse Worker" end
    child_spec = {Worker, {worker_args}}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def add_workers(0, _args), do: {:ok, :done}
  def add_workers(number, args) when is_integer(number) do
    add_worker(args)
    add_workers(number - 1, args)
  end

  # Terminate a Worker process and remove it from supervision
  def remove_worker(worker_pid) do
    DynamicSupervisor.terminate_child(__MODULE__, worker_pid)
  end

  # Nice utility method to check which processes are under supervision
  def children do
    DynamicSupervisor.which_children(__MODULE__)
  end

  # Nice utility method to check which processes are under supervision
  def count_children do
    DynamicSupervisor.count_children(__MODULE__)
  end
end