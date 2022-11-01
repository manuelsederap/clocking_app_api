defmodule ClockingAppApiWeb.WorkingTimeView do
  @moduledoc """
    The WorkingTime View
  """
  use ClockingAppApiWeb, :view

  def render("result.json", %{result: result}) do
    result
  end

  def render("working_time.json", %{result: nil}) do
    %{
      message: "Data not found"
    }
  end

  def render("working_time.json", %{result: working_time}) do
    %{
      id: working_time.id,
      user_id: working_time.user_id,
      start_date: working_time.start,
      end_date: working_time.end,
    }
  end

  def render("error.json", %{error: error}) do
    %{
      errors: error
    }
  end
end
