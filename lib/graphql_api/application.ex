defmodule GraphqlApi.Application do
  @moduledoc false

  use Application

  @topologies [
    state_replication: [
      strategy: Cluster.Strategy.Epmd,
      config: [
        hosts: [
          :node1@localhost,
          :node2@localhost,
          :node3@localhost
        ]
      ]
    ]
  ]

  @impl true
  def start(_type, _args) do
    children =
      [
        {Phoenix.PubSub, name: GraphqlApi.PubSub},
        GraphqlApiWeb.Endpoint,
        GraphqlApi.Repo,
        {DeltaCrdt, crdt: DeltaCrdt.AWLWWMap, name: :crdt_cache},
        GraphqlApiWeb.Cache.RequestsCache,
        {Redix, name: :redix},
        GraphqlApi.CrdtNodeManager
      ]

    children =
      case Application.get_env(:graphql_api, :env) do
        :dev ->
          [{Cluster.Supervisor, [@topologies, [name: GraphqlApiWeb.ClusterSupervisor]]}] ++ children

        _ ->
          children
      end

    opts = [strategy: :one_for_one, name: GraphqlApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GraphqlApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
