import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :graphql_api, GraphqlApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "RyikdmZHyy4BrgqHoRb72+2uwRSXGBAiJgRt1y/2RWU0m38Vd3Xn5M8Ql6w1jv6P",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :graphql_api, GraphqlApi.Repo,
  database: "graphql_api_repo_test",
  username: "postgres",
  password: "admin",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :graphql_api, :secret_key, "testkey"

# set the ttl for the cache entry in seconds for the auth tokens
config :graphql_api, cache_entry_ttl_in_ss: 1200

# set the max and min demand for the GenStage consumers
config :graphql_api, consumer_max_demand: 2
config :graphql_api, consumer_min_demand: 1
