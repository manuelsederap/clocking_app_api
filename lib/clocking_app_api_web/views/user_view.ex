defmodule ClockingAppApiWeb.UserView do
  @moduledoc """
    The User View
  """
  use ClockingAppApiWeb, :view

  def render("result.json", %{result: result}) do
    result
  end

  def render("user.json", %{result: nil}) do
    %{
      message: "User not found"
    }
  end

  def render("user.json", %{result: user}) do
    %{
      user_id: user.id,
      username: user.username,
      email: user.email,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end

  def render("error.json", %{error: error}) do
    %{
      errors: error
    }
  end
end
