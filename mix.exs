defmodule GraphqlApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :graphql_api,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {GraphqlApi.Application, []},
      extra_applications: [:logger, :runtime_tools, :con_cache]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:absinthe, "~> 1.7"},
      {:absinthe_phoenix, "~> 2.0"},
      {:absinthe_plug, "~> 1.5"},
      {:castore, "~> 1.0"},
      {:con_cache, "~> 1.0"},
      {:credo, "~> 1.7"},
      {:dataloader, "~> 1.0"},
      {:delta_crdt, "~> 0.6.4"},
      {:ecto_shorts, "~> 2.2"},
      {:ecto_sql, "~> 3.11"},
      {:jason, "~> 1.2"},
      {:libcluster, "~> 3.3"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:plug_cowboy, "~> 2.5"},
      {:poolboy, "~> 1.5"},
      {:postgrex, "~> 0.16.5"},
      {:redix, "~> 1.4"},
      {:request_cache_plug, "~> 1.0"},
      {:styler, "~> 0.11.1", only: [:dev, :test], runtime: false},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:phoenix, "~> 1.6.11"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      test: [
        "format",
        "compile",
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "test"
      ],
      "check.credo": "credo",
      "check.format": "format --check-formatted --check-equivalent --dry-run",
      "check.lint": ["check.format", "check.credo"],
      setup: ["ecto.drop", "ecto.create", "ecto.migrate"]
    ]
  end
end
