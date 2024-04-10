defmodule GraphqlApi.Accounts do
  @moduledoc """
  This module is responsible for managing the operations that can be made on the users.
  """
  alias EctoShorts.Actions
  alias GraphqlApi.Accounts.Preference
  alias GraphqlApi.Accounts.User

  require Logger

  def list_users(params) do
    params
    |> Map.drop([:before, :first, :after])
    |> create_query_with_preferences_filters()
    |> get_all_users(params)
  end

  @spec find_user(keyword() | map()) :: {:error, any()} | {:ok, %{optional(atom()) => any()}}
  def find_user(params) do
    Actions.find(User, params)
  end

  def get_user_with_preferences(%{id: id}) do
    Actions.find(User, %{id: id, preload: :preference})
  end

  def update_user(id, params) do
    Actions.update(User, id, params)
  end

  def create_user(params) do
    Actions.create(User, params)
  end

  def update_preferences(user, preferences) do
    Actions.update(Preference, user.preference.id, preferences)
  end

  defp create_query_with_preferences_filters(params) do
    Enum.reduce(params, User.join_preference(), &convert_field_to_query/2)
  end

  defp get_all_users(query, params) do
    Actions.all(query, params)
  end

  defp convert_field_to_query({likes_filter, value}, query) do
    User.by_user_preferences(query, {likes_filter, value})
  end
end
