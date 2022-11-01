defmodule ClockingAppApiWeb.WorkingTimeController do
  @moduledoc """
    The Working Time Controller.
  """
  use ClockingAppApiWeb, :controller

  alias ClockingAppApiWeb.WorkingTimeView, as: WTV # alias/import WorkingTimeView module
  alias ClockingAppApi.Contexts.WorkingTimeContext, as: WTC # alias/import WorkingTimeContext module
  alias ClockingAppApi.Contexts.UtilityContext, as: UC # alias/import UtilityContext module


  # controller function to create working time
  def create(conn, params) do
    :create
    |> WTC.validate_params(params) # call the context function that validate the parameters to create working time
    |> UC.valid_changeset # validate changeset return params if valid or return error changeset in tuple if invalid
    |> WTC.create_working_time # call the create function in context to insert data if valid or return error changeset if invalid
    |> return_result("working_time.json", conn) # call the return_result function to render the result in json format
  end

  # controller function to update working time
  def update(conn, params) do
    :update
    |> WTC.validate_params(params)
    |> UC.valid_changeset
    |> WTC.update_working_time
    |> return_result("result.json", conn)
  end

  # controller function to update working time
  def delete(conn, params) do
    :delete
    |> WTC.validate_params(params)
    |> UC.valid_changeset
    |> WTC.delete_working_time
    |> return_result("result.json", conn)
  end

  # controller function to get all working times based on user_id, start and end date
  def get_working_times(conn, params) do
    :get_working_items
    |> WTC.validate_params(params)
    |> UC.valid_changeset
    |> WTC.get_working_times
    |> return_result("result.json", conn)
  end

  # controller function to get a working time based on user_id and working time id
  def get_working_time(conn, params) do
    :get_working_item
    |> WTC.validate_params(params)
    |> UC.valid_changeset
    |> WTC.get_working_time
    |> return_result("working_time.json", conn)
  end

  # function that render error message result in json format with status code 400
  def return_result({:error, changeset}, _, conn) do
    conn
    |> put_status(400)
    |> put_view(WTV)
    |> render("error.json", error: UC.transform_error_message(changeset))
  end

  # if the return is valid, return json format data, with status code 200
  def return_result(result, json_name, conn) do
    conn
    |> put_status(200)
    |> put_view(WTV)
    |> render(json_name, result: result)
  end

end
