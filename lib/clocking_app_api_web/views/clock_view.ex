defmodule ClockingAppApiWeb.ClockView do
  @moduledoc """
    The User View
  """
  use ClockingAppApiWeb, :view

  def render("result.json", %{result: result}) do
    result
  end

  def render("clock.json", %{result: nil}) do
    %{
      message: "User not found"
    }
  end

  def render("clock.json", %{result: clock}) do
    %{
      clock_id: clock.id,
      user_id: clock.user_id,
      time: clock.time,
      status: clock.status
    }
  end

  def render("error.json", %{error: error}) do
    %{
      errors: error
    }
  end
end
