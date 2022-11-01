defmodule ClockingAppApi.Schemas.WorkingTimes do
  @moduledoc """
    The Working Time Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "working_times" do
    field :start, :naive_datetime
    field :end, :naive_datetime

    belongs_to :users, ClockingAppApi.Schemas.User, foreign_key: :user_id, type: :binary_id

    timestamps()
  end

  def changeset(struct, attrs) do
    struct
    |>cast(attrs, [
      :start,
      :end,
      :user_id
    ])
  end
end
