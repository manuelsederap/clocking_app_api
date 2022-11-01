defmodule ClockingAppApiWeb.UserController do
  @moduledoc """
    The User Controller -
    - from router.ex to controller, this module calls other functions
    especially the UserContext module functions to do business logic, like validating parameters and insert/update/fetch
    data in database
  """
  use ClockingAppApiWeb, :controller

  alias ClockingAppApiWeb.UserView # alias/import UserView module
  alias ClockingAppApi.Contexts.UserContext # alias/import UserContext module
  alias ClockingAppApi.Contexts.UtilityContext, as: UC # alias/import UtilityContext module

  def create_user(conn, params) do
    :create
    |> UserContext.validate_params(params)
    |> UC.valid_changeset
    |> UserContext.create_user
    |> return_result("user.json", conn)
  end

  def update_user(conn, params) do
    :update
    |> UserContext.validate_params(params)
    |> UC.valid_changeset
    |> UserContext.update_user(params["user_id"])
    |> return_result("result.json", conn)
  end

  def delete_user(conn, params) do
    :delete
    |> UserContext.validate_params(params) # call function from UserContext
    |> UC.valid_changeset
    |> UserContext.delete_user()
    |> return_result("result.json", conn)
  end

  def users(conn, params) do
    params
    |> UserContext.get_user_by_username_and_email
    |> return_result("result.json", conn)
  end

  def user(conn, params) do
    :get_user
    |> UserContext.validate_params(params)
    |> UC.valid_changeset
    |> UserContext.get_user_by_user_id()
    |> return_result("user.json", conn)
  end

  def return_result({:error, changeset}, _, conn) do
    conn
    |> put_status(400)
    |> put_view(UserView)
    |> render("error.json", error: UC.transform_error_message(changeset))
  end

  def return_result(result, json_name, conn) do
    conn
    |> put_status(200)
    |> put_view(UserView)
    |> render(json_name, result: result)
  end
end
