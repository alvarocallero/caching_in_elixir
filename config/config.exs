import Config

config :graphql_api,
  ecto_repos: [GraphqlApi.Repo]

config :ecto_shorts, repo: GraphqlApi.Repo, error_module: EctoShorts.Actions.Error

# Configures the endpoint
config :graphql_api, GraphqlApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: GraphqlApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: GraphqlApi.PubSub,
  live_view: [signing_salt: "/OZGv/gN"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :graphql_api, env: Mix.env()

config :request_cache_plug,
  enabled?: true,
  verbose?: true,
  graphql_paths: ["/graphiql", "/graphql"],
  conn_priv_key: :__shared_request_cache__,
  request_cache_module: GraphqlApiWeb.Cache.RequestsCache,
  default_ttl: :timer.hours(1),
  default_concache_opts: [
    ttl_check_interval: :timer.seconds(1),
    acquire_lock_timeout: :timer.seconds(1),
    ets_options: [write_concurrency: true, read_concurrency: true]
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
