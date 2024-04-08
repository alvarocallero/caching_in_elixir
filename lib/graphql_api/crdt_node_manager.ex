defmodule GraphqlApi.CrdtNodeManager do
  @moduledoc """
  This module is responsible for managing the CRDT nodes in the cluster.
  The set_neighbours is unidirectional meaning that we´re using it to set a specific cache node to have other nodes that
  it replicate to. So the :crdt_cache that we started in the application supervisor is synching to all other crdt_cache nodes.
  We're using Process.whereis(@cache_name) because that way it is able to use the PID as opposed to the name, which is not
  usable across nodes
  """

  use Task, restart: :transient

  alias GraphqlApi.Utils

  require Logger

  @cache_name :crdt_cache

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

  def get_state do
    Utils.string_keys_to_atom(DeltaCrdt.to_map(@cache_name))
  end

  def add_email_to_list(key, value) do
    Logger.debug("[CrdtNodeManager] Adding email to list")

    case DeltaCrdt.get(@cache_name, key) do
      nil -> DeltaCrdt.put(@cache_name, key, [value])
      list -> DeltaCrdt.put(@cache_name, key, list ++ [value])
    end
  end

  def update_user_email(old_email, new_email) do
    Logger.debug("[CrdtNodeManager] Updating email in list")
    emails = DeltaCrdt.get(@cache_name, :emails)

    new_list =
      Enum.map(emails, fn email ->
        if email == old_email, do: new_email, else: email
      end)

    DeltaCrdt.put(@cache_name, :emails, new_list)
  end
end
