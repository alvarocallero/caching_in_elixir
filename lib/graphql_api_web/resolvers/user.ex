defmodule GraphqlApiWeb.Resolver.User do
  @moduledoc """
  This module is the graphql resolver for the User type.
  """

  alias GraphqlApi.Accounts
  alias GraphqlApi.CrdtNodeManager

  require Logger

  def find_by_id(%{id: id}, _) do
    id = String.to_integer(id)
    Accounts.find_user(%{id: id})
  end

  def filter_by_preferences(params, _) do
    users = Accounts.list_users(params)
    {:ok, users}
  end

  def update(%{id: id} = params, _) do
    id = String.to_integer(id)
    params = Map.delete(params, :id)

    case Accounts.find_user(%{id: id}) do
      {:ok, old_user} ->
        case Accounts.update_user(id, params) do
          {:ok, user} ->
            CrdtNodeManager.update_user_email(old_user.email, user.email)
            {:ok, user}

          {:error, error} ->
            {:error, error}
        end

      {:error, error} ->
        {:error, error}
    end
  end

  def create(params, _) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        CrdtNodeManager.add_email_to_list(:emails, user.email)
        {:ok, user}

      {:error, error} ->
        {:error, error}
    end
  end

  def update_preferences(%{id: id} = params, _) do
    id = String.to_integer(id)

    with {:ok} <- empty_preferences?(params.preferences),
         {:ok, user} <- Accounts.get_user_with_preferences(%{id: id}),
         {:ok, _preference} <- Accounts.update_preferences(user, params.preferences) do
      {:ok, user}
    end
  end

  def get_app_state(_params, _) do
    state = CrdtNodeManager.get_state()
    {:ok, state}
  end

  defp empty_preferences?(preferences) when preferences === %{},
    do: {:error, %{message: "At least one preference must be provided", details: preferences}}

  defp empty_preferences?(_preferences), do: {:ok}
end
