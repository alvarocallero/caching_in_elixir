defmodule GraphqlApi.RequestsCounterStore do
  @moduledoc """
  Implementation of a cache in memory that uses DeltaCrdt to store the amount of GraphQL requests in a distributed way.
  The reasons of choosing DeltaCrdt are:
  1. It is a CRDT (Conflict-free Replicated Data Type) that allows to store the amount of requests in a distributed way.
  2. Since this app is quite small and the idea is to only have a few nodes, then the overhead of replicate the deltas is not a big deal.
  """

  use Task, restart: :transient

  require Logger

  @cache_name :requests_counter_store_cache

  @spec start_link(any()) :: {:ok, pid()}
  def start_link(_opts \\ []) do
    Task.start_link(fn ->
      nodes = Node.list()

      if Enum.any?(nodes) do
        DeltaCrdt.set_neighbours(@cache_name, Enum.map(nodes, &{@cache_name, &1}))

        Enum.each(nodes, fn node ->
          Logger.info("Subscribing to #{inspect(node)}")
          DeltaCrdt.set_neighbours({@cache_name, node}, [Process.whereis(@cache_name)])
        end)
      end
    end)
  end

  @spec get_request_counter(request_name :: String.t()) :: {:ok, term()} | {:error, term()}
  def get_request_counter(request_name) do
    case DeltaCrdt.get(@cache_name, request_name) do
      nil -> {:error, "request_name not found in cache"}
      value -> {:ok, value}
    end
  end

  @spec increment_request_counter(request_name :: String.t()) :: nil | {:ok, term()}
  def increment_request_counter(request_name) do
    case DeltaCrdt.get(@cache_name, request_name) do
      nil -> DeltaCrdt.put(@cache_name, request_name, 1)
      value -> DeltaCrdt.put(@cache_name, request_name, value + 1)
    end
  end
end
