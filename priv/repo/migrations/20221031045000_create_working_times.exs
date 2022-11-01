defmodule ClockingAppApi.Repo.Migrations.CreateWorkingTimes do
  use Ecto.Migration

  def up do
    create table(:working_times, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, type: :uuid)
      add :start, :naive_datetime
      add :end, :naive_datetime

      timestamps()
    end
  end

  def down do
    drop table(:working_times)
  end
end
