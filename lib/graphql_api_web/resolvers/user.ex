defmodule GraphqlApiWeb.Resolver.User do
  @moduledoc false

  alias GraphqlApi.Accounts
  alias GraphqlApi.RequestsCounterStore

  require Logger

  def find_by_id(%{id: id}, _) do
    RequestsCounterStore.increment_request_counter("user")
    id = String.to_integer(id)
    Accounts.find_user(%{id: id})
  end

  def filter_by_preferences(params, _) do
    RequestsCounterStore.increment_request_counter("users")
    users = Accounts.list_users(params)
    {:ok, users}
  end

  def update(%{id: id} = params, _) do
    RequestsCounterStore.increment_request_counter("update_user")
    id = String.to_integer(id)
    params = Map.delete(params, :id)
    Accounts.update_user(id, params)
  end

  def create(params, _) do
    RequestsCounterStore.increment_request_counter("create_user")

    case Accounts.create_user(params) do
      {:ok, user} ->
        {:ok, user}

      {:error, error} ->
        {:error, error}
    end
  end

  def update_preferences(%{id: id} = params, _) do
    RequestsCounterStore.increment_request_counter("update_user_preferences")
    id = String.to_integer(id)

    with {:ok} <- empty_preferences?(params.preferences),
         {:ok, user} <- Accounts.get_user_with_preferences(%{id: id}),
         {:ok, _preference} <- Accounts.update_preferences(user, params.preferences) do
      {:ok, user}
    end
  end

  defp empty_preferences?(preferences) when preferences === %{},
    do: {:error, %{message: "At least one preference must be provided", details: preferences}}

  defp empty_preferences?(_preferences), do: {:ok}
end
