defmodule ClockingAppApiWeb.Factory do
  @moduledoc "All mock data used for testing are defined here"
  use ExMachina.Ecto, repo: ClockingAppApi.Repo

  alias ClockingAppApi.Schemas.{
    Users,
    WorkingTimes,
    Clocks
  }

  def user_factory, do: %Users{}
  def working_time_factory, do: %WorkingTimes{}
  def clock_factory, do: %Clocks{}

end
