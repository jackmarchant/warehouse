defmodule Warehouse.Worker do
  require Logger

  def work(jobs) do
    Logger.info fn -> "Worker #{inspect self()} starting." end


    jobs
    |> Enum.map(&handle_task/1)
    |> Task.yield_many(:timer.seconds(20))
    |> process_results()
  end
  
  defp handle_task(%{id: job_id}) do
    Task.async(__MODULE__, :do_work, [job_id])
  end

  def do_work(job_id) do
    seconds = Enum.random(1..10)
    Process.sleep(:timer.seconds(seconds)) # asyncronous
    job_id
  end

  defp process_results(tasks) do
    tasks
    |> Enum.map(&maybe_get_response/1)
    |> Enum.map(&complete_task/1)
  end

  defp maybe_get_response({task, response}) do
    # Shutdown the tasks that did not reply nor exit
    response || Task.shutdown(task, :brutal_kill)
  end

  defp complete_task({:ok, response}) do
    Logger.info fn -> "Worker #{inspect self()} completed job: #{response}." end
  end
end