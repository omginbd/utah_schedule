defmodule UtahSchedule.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start_time, :time
      add :date, :date
      add :home_game, :boolean, default: false, null: false
      add :against, :string

      timestamps()
    end

    create unique_index(:games, [:against])
  end
end
