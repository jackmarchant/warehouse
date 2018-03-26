defmodule Warehouse.Manager do
  require Logger

  alias Warehouse.Worker

  def start_link(_opts) do
    Logger.debug fn -> "Starting Warehouse Manager" end
    Task.Supervisor.start_link(name: __MODULE__)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :transient,
      shutdown: 500
    }
  end

  def start_worker(jobs) do
    Task.Supervisor.start_child(__MODULE__, Worker, :work, [jobs], [])
  end

  def start_workers(_, 0), do: Logger.debug fn -> "Warehouse Manager has delegated all jobs." end
  def start_workers(jobs, number_of_workers) do
    sliced_jobs =
      jobs
      |> Enum.shuffle()
      |> Enum.slice(0, 10)
    
    start_worker(sliced_jobs)

    start_workers(jobs -- sliced_jobs, number_of_workers - 1)
  end
end