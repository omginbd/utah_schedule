defmodule UtahSchedule.Repo do
  use Ecto.Repo,
    otp_app: :utah_schedule,
    adapter: Ecto.Adapters.SQLite3
end
