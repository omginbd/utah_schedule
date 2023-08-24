defmodule UtahSchedule.Game do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "games" do
    field :against, :string
    field :home_game, :boolean, default: false
    field :date, :date
    field :start_time, :time

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:start_time, :date, :home_game, :against])
    |> validate_required([:start_time, :date, :home_game, :against])
  end
end
