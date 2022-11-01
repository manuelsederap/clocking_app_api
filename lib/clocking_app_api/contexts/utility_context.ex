defmodule ClockingAppApi.Contexts.UtilityContext do
  @moduledoc """
    The Utility Context.
  """
  # function that validate changeset, return boolean
  def is_valid_changeset?(changeset), do: {changeset.valid?, changeset}

  def valid_changeset({true, {map, changeset}}), do: {map, changeset}
  def valid_changeset({false, {_map, changeset}}), do: {:error, changeset}
  def valid_changeset({true, changeset}), do: changeset.changes
  def valid_changeset({false, changeset}), do: {:error, changeset}

  def transform_error_message(changeset) do
    errors = Enum.map(changeset.errors, fn({key, {message, _}}) ->
      %{
        key => transform_required(key, message)
      }
    end)

    Enum.reduce(errors, fn(head, tail) ->
      Map.merge(head, tail)
    end)
  end

  defp transform_required(key, message), do: "#{message}"
end
