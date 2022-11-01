defmodule ClockingAppApi.Schemas.Users do
  @moduledoc """
    The User Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :username, :string
    field :email, :string

    timestamps()
  end

  def changeset(struct, attrs) do
    struct
    |>cast(attrs, [
      :username,
      :email
    ])
  end
end
