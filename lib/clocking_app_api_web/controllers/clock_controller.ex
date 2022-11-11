defmodule ClockingAppApiWeb.ClockController do
  @moduledoc """
    The Clock Controller.
  """
  use ClockingAppApiWeb, :controller

  alias ClockingAppApi.Contexts.UtilityContext, as: UC # alias/import UtilityContext module
  alias ClockingAppApi.Contexts.ClockContext, as: CC # alias/import ClockContext module
  alias ClockingAppApiWeb.ClockView, as: CV # alias/import ClockView module

  # test commit

  def clock_in(conn, params) do
    :clock_in
    |> CC.validate_params(params)
    |> UC.valid_changeset
    |> CC.clock_in
    |> return_result("result.json", conn)
  end

  def get_user_clock(conn, params) do
    :get_user_clock
    |> CC.validate_params(params)
    |> UC.valid_changeset
    |> CC.get_user_clock
    |> return_result("result.json", conn)
  end

  def get_all_clocks(conn, _params) do
    CC.get_all_clocks
    |> return_result("result.json", conn)
  end

  # function that render error message result in json format with status code 400
  def return_result({:error, changeset}, _, conn) do
    conn
    |> put_status(400)
    |> put_view(CV)
    |> render("error.json", error: UC.transform_error_message(changeset))
  end

  # if the return is valid, return json format data, with status code 200
  def return_result(result, json_name, conn) do
    conn
    |> put_status(200)
    |> put_view(CV)
    |> render(json_name, result: result)
  end
end
