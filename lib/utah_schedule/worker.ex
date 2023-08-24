defmodule UtahSchedule.Worker do
  use Oban.Worker

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    UtahSchedule.get_schedule()
    :ok
  end
end
