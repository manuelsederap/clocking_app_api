defmodule ClockingAppApi.Contexts.ClockContext do
  @moduledoc """
    The Working Time Context.
  """

  use Timex

  import Ecto.Changeset
  import Ecto.Query

  alias ClockingAppApi.Repo
  alias ClockingAppApi.Contexts.UtilityContext, as: UC
  alias ClockingAppApi.{
    Schemas.Clocks,
    Schemas.Users
  }

  # validate parameter for create
  def validate_params(:clock_in, params) do
    fields = %{
      user_id: :binary_id,
      time: :string,
      status: :boolean
    }

    {%{}, fields}
    |> cast(params, Map.keys(fields))
    |> validate_required(:user_id, message: "Enter User id")
    |> validate_required(:time, message: "Enter time")
    |> validate_required(:status, message: "Enter status")
    |> validate_format(:user_id, ~r/(^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$)/, message: "Invalid User Id") #changeset validation format if user id is UUID valid
    |> validate_format(:time, ~r/[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]) (2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]/, message: "time is in invalid format. Date should be in YYYY-MM-DD HH:mm:ss")
    |> validate_inclusion(:status, [true, false], message: "status is invalid, allowed values are: true or false")
    |> validate_user
    |> UC.is_valid_changeset?
  end

  def validate_params(:get_user_clock, params) do
    field = %{
      user_id: :binary_id
    }

    {%{}, field}
    |> cast(params, Map.keys(field))
    |> validate_required(:user_id, message: "Enter User id")
    |> validate_format(:user_id, ~r/(^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$)/, message: "Invalid User Id") #changeset validation format if user id is UUID valid
    |> validate_user
    |> UC.is_valid_changeset?
  end

  def validate_user(%{valid?: false} = changeset), do: changeset
  def validate_user(%{changes: %{user_id: user_id}} = changeset) do
    case  Users |> Repo.get_by(%{id: user_id}) do
      nil -> add_error(changeset, :username, "User not found")
      _ -> changeset
    end
  end

  def clock_in({:error, changeset}), do: {:error, changeset}
  def clock_in(params) do
    user_id = params[:user_id]
    user_id
    |> check_if_clock_in_or_clock_out(params)
    |> verify_if_clock_in_or_clock_out(params)
    |> insert_clock_data()

  end

  def check_if_clock_in_or_clock_out(user_id, params) do
    Clocks
    |> where([c], c.user_id == ^user_id and c.status == true)
    |> order_by([c], desc: c.inserted_at)
    |> Repo.all()
    |> List.first()
    # |> raise()
  end

  def verify_if_clock_in_or_clock_out(nil, params), do: params |> Map.put(:clockin, true)
  def verify_if_clock_in_or_clock_out(clock, params) do
    user_clock = clock.time
    req_clock = Timex.parse!(params[:time], "{ISO:Extended}")
    check_time_diff(NaiveDateTime.diff(req_clock, user_clock, :second), params, user_clock, req_clock)
  end

  def check_time_diff(time_diff, params, _, _) when time_diff >= 86400 do
    params |> Map.put(:clockin, true)
  end

  def check_time_diff(time_diff, params, user_clock, req_clock) when time_diff < 86400 do
    {user_clock_year, user_clock_month, user_clock_day} = transform_date(NaiveDateTime.to_date(user_clock))
    {req_clock_year, req_clock_month, req_clock_day} = transform_date(NaiveDateTime.to_date(req_clock))

    if user_clock_year == req_clock_year and user_clock_month == req_clock_month and user_clock_day == req_clock_day do
      case NaiveDateTime.compare(user_clock, req_clock) do
        :lt ->
          params |> Map.put(:clockin, false)
        :gt ->
          params |> Map.put(:clockin, true)
        _ ->
          params |> Map.put(:clockin, false)
      end
    else
      params |> Map.put(:clockin, true)
    end
  end

  defp transform_date(datetime) do
    datetime
    |> to_string
    |> String.split(" ")
    |> Enum.at(0)
    |> String.split("-")
    |> List.to_tuple()
  end

  def insert_clock_data(%{clockin: true} = params) do
    %Clocks{}
    |> Clocks.changeset(%{
      user_id: params[:user_id],
      time: params[:time],
      status: true
    })
    |> Repo.insert!()
  end

  def insert_clock_data(%{clockin: false} = params) do
    %Clocks{}
    |> Clocks.changeset(%{
      user_id: params[:user_id],
      time: params[:time],
      status: false
    })
    |> Repo.insert!()
  end

  def get_user_clock({:error, changeset}), do: {:error, changeset}
  def get_user_clock(params) do
    Clocks
    |> where([c], c.user_id == ^params[:user_id])
    |> select([c], %{
      clock_id: c.id,
      user_id: c.user_id,
      time: c.time,
      status: c.status
    })
    |> Repo.all()
  end

  # Check result of Repo, if return ok, return Success message
  def result_checker({:ok, _}, :update), do: %{message: "Successfully Updated"}

  # Check result of Repo, if return not ok, return Error message
  def result_checker({_, _}, :update), do: %{message: "Error Updating.."}

  # Check result of Repo, if return ok, return Success message
  def result_checker({:ok, _}, :delete), do: %{message: "Successfully Deleted"}

  # Check result of Repo, if return not ok, return Error message
  def result_checker({_, _}, :delete), do: %{message: "Error Deleting.."}

end
