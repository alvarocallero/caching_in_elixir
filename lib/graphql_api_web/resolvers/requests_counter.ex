defmodule GraphqlApiWeb.Resolver.RequestsCounter do
  @moduledoc false
  alias GraphqlApi.RequestsCounterStore

  def get_requests_hits(%{key: key}, _) do
    case RequestsCounterStore.get_request_counter(key) do
      {:ok, hit_counter} -> {:ok, hit_counter}
      _ -> {:error, %{message: "not found", details: "the key did not match with any request"}}
    end
  end
end
