import Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :graphql_api, GraphqlApiWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: String.to_integer(System.get_env("PORT", "4000"))],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "hTGXqrTNgscY0QlE4MVnX2jZZF+ma7Do1tgS2M2rl2iHogKH7mgd8HgyY6wkwMQp",
  watchers: []

config :graphql_api, GraphqlApi.Repo,
  database: "graphql_api_repo_dev",
  username: "postgres",
  password: "admin",
  hostname: "localhost"

config :graphql_api, :secret_key, "$ekretkey"

# Configuration for log level
config :logger, :console, level: :debug, format: "[$level] [$date] [$time] $message\n\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# set the ttl for the cache entry in seconds for the auth tokens
config :graphql_api, cache_entry_ttl_in_ss: 180

# set the values for the redis cache for the graphql requests
config :graphql_api, redis_pool_name: :redis_graphql_cache
config :graphql_api, redis_pool_size: 5
config :graphql_api, redis_max_overflow: 15
config :graphql_api, redis_ttl_in_seconds: 15
