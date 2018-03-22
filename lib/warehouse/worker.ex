defmodule Warehouse.Worker do
  use GenServer

  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def start_link([], {args}) do
    start_link({args})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    Logger.debug fn -> "Warehouse.Worker #{inspect self()} working..." end
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 10_000) # 10 seconds
  end
end