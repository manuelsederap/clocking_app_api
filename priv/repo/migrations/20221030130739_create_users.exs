defmodule ClockingAppApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :username, :string
      add :email, :string

      timestamps()
  end

    create unique_index(:users, [:username])
  end

  def down do
    drop table(:users)
  end
end
