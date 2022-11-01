defmodule ClockingAppApi.Contexts.WorkingTimeContext do
  @moduledoc """
    The Working Time Context.
  """

  import Ecto.Changeset
  import Ecto.Query

  alias ClockingAppApi.Repo
  alias ClockingAppApi.Contexts.UtilityContext, as: UC
  alias ClockingAppApi.{
    Schemas.WorkingTimes
  }

  # validate parameter for create
  def validate_params(:create, params) do
    fields = %{
      user_id: :binary_id,
      start: :string,
      end: :string
    }

    {%{}, fields}
    |> cast(params, Map.keys(fields))
    |> validate_required(:user_id, message: "Enter User id")
    |> validate_required(:start, message: "Enter Start date")
    |> validate_required(:end, message: "Enter End date")
    |> validate_format(:user_id, ~r/(^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$)/, message: "Invalid User Id") #changeset validation format if user id is UUID valid
    |> validate_format(:start, ~r/[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]) (2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]/, message: "start date is in invalid format. Date should be in YYYY-MM-DD HH:mm:ss")
    |> validate_format(:end, ~r/[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]) (2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]/, message: "end date is in invalid format. Date should be in YYYY-MM-DD HH:mm:ss")
    |> UC.is_valid_changeset?
  end

  # validate parameter for update
  def validate_params(:update, params) do
    fields = %{
      id: :binary_id,
      start: :string,
      end: :string
    }

    {%{}, fields}
    |> cast(params, Map.keys(fields))
    |> validate_required(:id, message: "Enter Working Time id")
    |> validate_required(:start, message: "Enter Start date")
    |> validate_required(:end, message: "Enter End date")
    |> validate_format(:id, ~r/(^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$)/, message: "Invalid Id, Please check your id") #changeset validation format if user id is UUID valid
    |> validate_format(:start, ~r/[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]) (2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]/, message: "start date is in invalid format. Date should be in YYYY-MM-DD HH:mm:ss")
    |> validate_format(:end, ~r/[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]) (2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]/, message: "end date is in invalid format. Date should be in YYYY-MM-DD HH:mm:ss")
    |> validate_if_working_time_exist(:update)
    |> UC.is_valid_changeset?
  end

  #validate parameter for delete
  def validate_params(:delete, params) do
    field = %{
      id: :binary_id
    }

    {%{}, field}
    |> cast(params, Map.keys(field))
    |> validate_format(:id, ~r/(^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$)/, message: "Invalid Id, Please check your id") #changeset validation format if user id is UUID valid
    |> validate_if_working_time_exist(:delete)
    |> UC.is_valid_changeset?
  end

  #validate parameter for get_working_items
  def validate_params(:get_working_items, params) do
    fields = %{
      user_id: :binary_id,
      start: :string,
      end: :string
    }

    {%{}, fields}
    |> cast(params, Map.keys(fields))
    |> validate_required(:user_id, message: "Enter User id")
    |> validate_required(:start, message: "Enter Start date")
    |> validate_required(:end, message: "Enter End date")
    |> validate_format(:user_id, ~r/(^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$)/, message: "Invalid Id, Please check your User id") #changeset validation format if user id is UUID valid
    |> validate_format(:start, ~r/[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]) (2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]/, message: "start date is in invalid format. Date should be in YYYY-MM-DD HH:mm:ss")
    |> validate_format(:end, ~r/[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1]) (2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]/, message: "end date is in invalid format. Date should be in YYYY-MM-DD HH:mm:ss")
    |> UC.is_valid_changeset?
  end

  #validate parameter for get_working_item
  def validate_params(:get_working_item, params) do
    fields = %{
      id: :binary_id,
      user_id: :binary_id
    }

    {%{}, fields}
    |> cast(params, Map.keys(fields))
    |> validate_required(:user_id, message: "Enter User id")
    |> validate_required(:id, message: "Enter Working Time id")
    |> validate_format(:id, ~r/(^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$)/, message: "Invalid Id, Please check your id") #changeset validation format if user id is UUID valid
    |> validate_format(:user_id, ~r/(^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$)/, message: "Invalid Id, Please check your User id") #changeset validation format if user id is UUID valid
    |> UC.is_valid_changeset?
  end

  def validate_if_working_time_exist(%{valid?: false} = changeset, _), do: changeset
  def validate_if_working_time_exist(%{changes: %{id: id}} = changeset, action) do
    case  WorkingTimes |> Repo.get_by(%{id: id}) do
      nil -> add_error(changeset, :id, "Unable to #{Atom.to_string(action)} Working Time not found")
      _ -> changeset
    end
  end

  def create_working_time({:error, changeset}), do: {:error, changeset}
  def create_working_time(params) do
    working_time =
      %WorkingTimes{}
      |> WorkingTimes.changeset(params)
      |> Repo.insert!()
  end

  def update_working_time({:error, changeset}), do: {:error, changeset}
  def update_working_time(params) do
    working_time = get_working_time_by_id(params[:id])
    working_time
    |> WorkingTimes.changeset(%{
      start: params[:start],
      end: params[:end]
    })
    |> Repo.update()
    |> result_checker(:update)
  end

  def delete_working_time({:error, changeset}), do: {:error, changeset}
  def delete_working_time(%{id: id}) do
    working_time = get_working_time_by_id(id)
    working_time
    |> Repo.delete()
    |> result_checker(:delete)
  end

  def get_working_times({:error, changeset}), do: {:error, changeset}
  def get_working_times(params) do
    WorkingTimes
    |> where([wtc], wtc.user_id == ^params[:user_id])
    |> where([wtc], wtc.start == ^params[:start] and wtc.end == ^params[:end])
    |> select([wtc], %{
      id: wtc.id,
      user_id: wtc.user_id,
      start: wtc.start,
      end: wtc.end
    })
    |> order_by([wtc], desc: wtc.inserted_at)
    |> Repo.all()
  end

  def get_working_time({:error, changeset}), do: {:error, changeset}
  def get_working_time(params) do
    WorkingTimes
    |> where([wtc], wtc.id == ^params[:id] and wtc.user_id == ^params[:user_id])
    |> select([wtc], %{
      id: wtc.id,
      user_id: wtc.user_id,
      start: wtc.start,
      end: wtc.end
    })
    |> Repo.one()
  end

  def get_working_time_by_id(id), do: WorkingTimes |> Repo.get_by(%{id: id})

  # Check result of Repo, if return ok, return Success message
  def result_checker({:ok, _}, :update), do: %{message: "Successfully Updated"}

  # Check result of Repo, if return not ok, return Error message
  def result_checker({_, _}, :update), do: %{message: "Error Updating.."}

  # Check result of Repo, if return ok, return Success message
  def result_checker({:ok, _}, :delete), do: %{message: "Successfully Deleted"}

  # Check result of Repo, if return not ok, return Error message
  def result_checker({_, _}, :delete), do: %{message: "Error Deleting.."}

end
