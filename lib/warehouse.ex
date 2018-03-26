defmodule Warehouse do
  @moduledoc """
  Documentation for Warehouse.
  """

  alias Warehouse.Job
  
  def send_orders(quantity) when quantity <= 10 do
    quantity
    |> build_jobs()
    |> Warehouse.Manager.start_worker()
  end
  
  def send_orders(quantity) when quantity > 10 do
    quantity
    |> build_jobs()
    |> Warehouse.Manager.start_workers(round(quantity / 10)) # how to dynamically allocate workers per job
  end

  defp build_jobs(_, accumulator \\ [])
  defp build_jobs(0, accumulator), do: accumulator
  defp build_jobs(quantity, accumulator) do
    build_jobs(quantity - 1, accumulator ++ [Job.create(quantity)])
  end
end
