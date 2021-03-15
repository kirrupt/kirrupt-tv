defmodule KirruptTv.Mixfile do
  use Mix.Project

  def project do
    [app: :kirrupt_tv,
     version: "0.0.1",
     elixir: "~> 1.5",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {KirruptTv, []},
    extra_applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :mariaex, :timex, :timex_ecto, :sentry,
                    :comeonin, :arc]]
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
     {:phoenix_ecto, "~> 3.0"},
     {:mariaex, "~> 0.8.2"},
     {:phoenix_html, "~> 2.14"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:plug_cowboy, "~> 2.1"},
     {:timex, "~> 3.0"},
     {:timex_ecto, "~> 3.0"},
     {:html_sanitize_ex, "~> 1.0.0"},
     {:sentry, "~> 6.0"},
     {:sweet_xml, "~> 0.6.2"},
     {:comeonin, "~> 2.5"},
     {:arc, "~> 0.11.0"},
     {:quantum, ">= 2.2.0"},
     {:jason, "~> 1.2"},
     {:phoenix_live_dashboard, "~> 0.1"},
     {:telemetry_poller, "~> 0.4"},
     {:telemetry_metrics, "~> 0.4"},
     {:excoveralls, "~> 0.12", only: :test},
     {:httpoison, "~> 1.8"},
     {:elixir_uuid, "~> 1.2"}]
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
