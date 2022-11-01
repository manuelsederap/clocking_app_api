defmodule ClockingAppApi.Contexts.UserContext do
  @moduledoc """
    The User Context.
  """

  import Ecto.Changeset
  import Ecto.Query

  alias ClockingAppApi.Repo
  alias ClockingAppApi.Contexts.UtilityContext, as: UC
  alias ClockingAppApi.{
    Schemas.Users
  }

  # this function validate params when creating user
  def validate_params(:create, params) do
    fields = %{
      username: :string,
      email: :string
    }

    {%{}, fields}
    |> cast(params, Map.keys(fields))
    |> validate_required(:username, message: "Enter username") # changeset validator, check if user input null/empty username
    |> validate_required(:email, message: "Enter email") # changeset validator, check if user input null/empty email
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, message: "Invalid email") #changeset validation format if email is valid
    |> validate_username_if_already_exists()
    |> UC.is_valid_changeset?
  end

  # this function validate params when updating user
  def validate_params(:update, params) do
    fields = %{
      user_id: :binary_id,
      username: :string,
      email: :string
    }

    {%{}, fields}
    |> cast(params, Map.keys(fields))
    |> validate_required(:username, message: "Enter username")
    |> validate_required(:email, message: "Enter email")
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, message: "Invalid email")
    |> validate_format(:user_id, ~r/(^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$)/, message: "Invalid User Id") #changeset validation format if user id is UUID valid
    |> validate_username_if_already_exists
    |> UC.is_valid_changeset?
  end

  def validate_params(:delete, params) do
    fields = %{
      user_id: :binary_id
    }

    {%{}, fields}
    |> cast(params, Map.keys(fields))
    |> validate_format(:user_id, ~r/(^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$)/, message: "Invalid User Id") #changeset validation format if user id is UUID valid
    |> UC.is_valid_changeset?
  end

  def validate_params(:get_user, params) do
    fields = %{
      user_id: :binary_id
    }

    {%{}, fields}
    |> cast(params, Map.keys(fields))
    |> validate_format(:user_id, ~r/(^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$)/, message: "Invalid User Id") #changeset validation format if user id is UUID valid
    |> UC.is_valid_changeset?
  end

  def create_user({:error, changeset}), do: {:error, changeset} # function that catch error (invalid changeset)
  def create_user(params) do
    %Users{}
    |> Users.changeset(params)
    |> Repo.insert!()
  end

  def update_user({:error, changeset}, _), do: {:error, changeset} # function that catch error (invalid changeset)
  def update_user(params, user_id) do
    user = get_user_by_id(user_id)
    case user do
      nil ->
        %{message: "User not found"}
      _ ->
        user
        |> Users.changeset(%{
          username: params.username,
          email: params.email
        })
        |> Repo.update()
        |> result_checker(:update)
    end
  end
  def delete_user({:error, changeset}), do: {:error, changeset} # function that catch error (invalid changeset)
  def delete_user(%{user_id: user_id}) do
    user = get_user_by_id(user_id)
    case user do ## check if user is null, if null return json response "User not found"
      nil ->
        %{message: "User not found"}
      _ ->
        user
        |> Repo.delete()
        |> result_checker(:delete)
    end
  end

  def get_user_by_username_and_email(params) do
    username = params["username"]
    email = params["email"]
    Users
    |> where([u], u.username == ^username and u.email == ^email)
    |> select([u], %{
      user_id: u.id
      })
    |> Repo.one
  end

  def get_user_by_user_id({:error, changeset}), do: {:error, changeset} # function that catch error (invalid changeset)
  def get_user_by_user_id(%{user_id: user_id}) do
    Users
    |> where([u], u.id == ^user_id)
    |> Repo.one
  end

  # validate if username is already exist in database
  def validate_username_if_already_exists(%{valid?: false} = changeset), do: changeset
  def validate_username_if_already_exists(%{changes: %{username: username}} = changeset) do
    case  Users |> Repo.get_by(%{username: username}) do
      nil -> changeset
      _ -> add_error(changeset, :username, "Username already Taken")
    end
  end

  # get the user using user_id parameter
  def get_user_by_id(id), do: Users |> Repo.get_by(%{id: id})

  # Check result of Repo, if return ok, return Success message
  def result_checker({:ok, _}, :update), do: %{message: "Successfully Updated"}

  # Check result of Repo, if return not ok, return Error message
  def result_checker({_, _}, :update), do: %{message: "Error Updating.."}

  # Check result of Repo, if return ok, return Success message
  def result_checker({:ok, _}, :delete), do: %{message: "Successfully Deleted"}

  # Check result of Repo, if return not ok, return Error message
  def result_checker({_, _}, :delete), do: %{message: "Error Deleting.."}

  # Check result of Repo of get user, if return is nil, return message User not found
  def result_checker(nil, :get_user), do: %{message: "User not found"}

  # Check result of Repo of get user, if return is not nil, return the User
  def result_checker(user, :get_user), do: user

end
