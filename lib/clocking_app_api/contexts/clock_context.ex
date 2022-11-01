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
    |> validate_user_if_exist
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
    |> validate_user_if_exist
    |> UC.is_valid_changeset?
  end

  # validate user if exist in database
  def validate_user_if_exist(%{valid?: false} = changeset), do: changeset
  def validate_user_if_exist(%{changes: %{user_id: user_id}} = changeset) do
    case  Users |> Repo.get_by(%{id: user_id}) do
      nil -> add_error(changeset, :username, "User not found")
      _ -> changeset
    end
  end

  def clock_in({:error, changeset}), do: {:error, changeset}
  def clock_in(params) do
    user_id = params[:user_id]
    user_id
    |> get_clock_user_latest_data()
    |> verify_if_clock_in_or_clock_out(params)
    |> insert_clock_data()

  end

  # fetch latest clock data of the user based on the time inserted in DB
  def get_clock_user_latest_data(user_id) do
    Clocks
    |> where([c], c.user_id == ^user_id)
    |> order_by([c], desc: c.inserted_at)
    |> Repo.all()
    |> List.first()
  end

  # if data is nil, User tag as clock-in
  def verify_if_clock_in_or_clock_out(nil, params), do: params |> Map.put(:clockin, true)
  # if data found, check the clock in datetime compare into request time parameter
  def verify_if_clock_in_or_clock_out(clock, params) do
    user_clock = clock.time
    req_clock = Timex.parse!(params[:time], "{ISO:Extended}")

    # if the latest user clock data status is true and the time is early than request time parameter
    if clock.status == true and NaiveDateTime.compare(user_clock, req_clock) == :lt do
      # User will tag as clock-out
      params |> Map.put(:clockin, false)
    else
      # else User will tag as clock-in
      params |> Map.put(:clockin, true)
    end
  end

  # insert data pattern matching the User tag, if User tag clockin is true, status is true
  def insert_clock_data(%{clockin: true} = params) do
    %Clocks{}
    |> Clocks.changeset(%{
      user_id: params[:user_id],
      time: params[:time],
      status: true
    })
    |> Repo.insert!()
  end

  # insert data pattern matchinng the User tag, if User tag clockin is false, status is false
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
    |> order_by([c], desc: c.inserted_at)
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
