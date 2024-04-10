defmodule GraphqlApi.CrdtNodeManager do
  @moduledoc """
  This module is responsible for managing the CRDT nodes in the cluster.
  The set_neighbours is unidirectional meaning that we need to execute it from node A to B, and vice versa.
  We're using Process.whereis(@cache_name) because that way it is able to use the PID as opposed to the name, which is not
  usable across nodes.
  The state to be shared between the nodes is a list of all the emails of the users.
  """

  use Task, restart: :transient

  alias GraphqlApi.Utils

  require Logger

  @cache_name :crdt_cache

  def start_link(_opts \\ []) do
    Task.start_link(fn ->
      nodes = Node.list()

      if Enum.any?(nodes) do
        DeltaCrdt.set_neighbours(@cache_name, Enum.map(nodes, &{@cache_name, &1}))

        Enum.each(nodes, fn node ->
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

    new_list =
      case DeltaCrdt.get(@cache_name, :emails) do
        nil ->
          nil

        _ ->
          Enum.map(DeltaCrdt.get(@cache_name, :emails), fn email ->
            if email == old_email, do: new_email, else: email
          end)
      end

    DeltaCrdt.put(@cache_name, :emails, new_list)
  end
end
