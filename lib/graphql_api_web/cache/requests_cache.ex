defmodule GraphqlApiWeb.Cache.RequestsCache do
  @moduledoc """
  This module is responsible for caching graphql requests using Redis as the cache system with Poolboy to manage the transactions.
  The value of the ttl provided will be in seconds.
  """

  @pool_name Application.compile_env(:graphql_api, :redis_graphql_cache)
  @pool_size Application.compile_env(:graphql_api, :redis_pool_size)
  @max_overlow Application.compile_env(:graphql_api, :redis_max_overflow)

  def child_spec(_opts) do
    :poolboy.child_spec(
      @pool_name,
      name: {:local, @pool_name},
      worker_module: Redix,
      size: @pool_size,
      max_overflow: @max_overlow
    )
  end

  def put(key, ttl, value) do
    :poolboy.transaction(@pool_name, fn pid ->
      with {:ok, "OK"} <-
             Redix.command(pid, [
               "SETEX",
               key,
               ttl,
               :erlang.term_to_binary(value)
             ]) do
        :ok
      end
    end)
  end

  def get(key) do
    :poolboy.transaction(@pool_name, fn pid ->
      with {:ok, value} <- Redix.command(pid, ["GET", key]) do
        if is_binary(value) do
          {:ok, :erlang.binary_to_term(value)}
        else
          {:ok, value}
        end
      end
    end)
  end
end
