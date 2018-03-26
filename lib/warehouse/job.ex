defmodule Warehouse.Job do
  defstruct [:id, :name]

  def create(id) do
    %__MODULE__{
      id: id,
      name: "job-#{id}"
    }
  end
end