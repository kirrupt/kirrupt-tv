# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :kirrupt_tv,
  ecto_repos: [KirruptTv.Repo]

# Configures the endpoint
config :kirrupt_tv, KirruptTv.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9fBcrjyVj50bjDHq/pxoX6ImrGKsLK0IfRm55NEiH9x8/GNOM8ZVrN53VqKFywHN",
  render_errors: [view: KirruptTv.ErrorView, accepts: ~w(html json)],
  pubsub: [name: KirruptTv.PubSub,
           adapter: Phoenix.PubSub.PG2],
  fanart_key: "e5b2ae915bf77dc6f0ebb1af149c27ce"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n", metadata: [:file, :line],
  metadata: [:request_id]

# Configures Sentry's Logger
config :sentry,
  use_error_logger: true,
  environment_name: :dev

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :arc,
  storage: Arc.Storage.Local

pool = if System.get_env("MYSQL_DB") == "kirrupt_test" do
  Ecto.Adapters.SQL.Sandbox
else
  DBConnection.Poolboy
end

config :kirrupt_tv, KirruptTv.Repo,
  adapter: Ecto.Adapters.MyXQL,
  username: System.get_env("MYSQL_USER"),
  password: System.get_env("MYSQL_PASS"),
  database: System.get_env("MYSQL_DB"),
  hostname: System.get_env("MYSQL_HOST"),
  pool_size: 10,
  pool: pool
