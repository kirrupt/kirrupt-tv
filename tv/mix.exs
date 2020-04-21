defmodule KirruptTv.MixProject do
  use Mix.Project

  def project do
    [app: :kirrupt_tv,
     version: "0.0.1",
     elixir: "~> 1.7",
     elixirc_paths: elixirc_paths(Mix.env()),
     compilers: [:phoenix, :gettext] ++ Mix.compilers(),
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {KirruptTv, []},
      extra_applications: [:logger, :runtime_tools],
      #applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
      #              :phoenix_ecto, :myxql, :timex, :httpotion, :sentry,
      #              :comeonin]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web", "test/support"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.5"},
     {:phoenix_pubsub, "~> 2.0"},
     {:phoenix_ecto, "~> 4.1"},
     {:ecto_sql, "~> 3.4"},
     {:myxql, ">= 0.0.0"},
     {:phoenix_html, "~> 2.14"},
     {:phoenix_live_reload, "~> 1.2", only: :dev},
     {:phoenix_live_dashboard, "~> 0.2.0"},
     {:telemetry_metrics, "~> 0.4"},
     {:telemetry_poller, "~> 0.4"},
     {:jason, "~> 1.0"},
     {:gettext, "~> 0.17"},
     {:plug_cowboy, "~> 2.2"},
     {:timex, "~> 3.6"},
     {:httpotion, "~> 3.1"},
     {:html_sanitize_ex, "~> 1.4"},
     {:sentry, "~> 7.2"},
     {:sweet_xml, "~> 0.6"},
     {:comeonin, "~> 5.3"},
     {:arc, "~> 0.11"},
     {:quantum, "~> 2.4"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
