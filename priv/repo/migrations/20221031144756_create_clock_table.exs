defmodule ClockingAppApi.Repo.Migrations.CreateClockTable do
  use Ecto.Migration

  def up do
    create table(:clocks, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, type: :uuid)
      add :time, :naive_datetime
      add :status, :boolean

      timestamps()
    end
  end

  def down do
    drop table(:clocks)
  end
end
