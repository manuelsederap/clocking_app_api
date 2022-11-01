defmodule ClockingAppApi.Schemas.Clocks do
  @moduledoc """
    The Clock Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "clocks" do
    field :time, :naive_datetime
    field :status, :boolean

    belongs_to :users, ClockingAppApi.Schemas.User, foreign_key: :user_id, type: :binary_id

    timestamps()
  end

  def changeset(struct, attrs) do
    struct
    |>cast(attrs, [
      :time,
      :status,
      :user_id
    ])
  end
end
