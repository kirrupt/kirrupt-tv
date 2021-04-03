# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

defmodule ConfigHelpers do
  def get_env_with_fallback(key, fallback) do
    case System.get_env(key) do
      nil -> fallback
      value -> value
    end
  end
end

# General application configuration
config :kirrupt_tv,
  ecto_repos: [KirruptTv.Repo]

# Configures the endpoint
config :kirrupt_tv, KirruptTv.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9fBcrjyVj50bjDHq/pxoX6ImrGKsLK0IfRm55NEiH9x8/GNOM8ZVrN53VqKFywHN",
  render_errors: [view: KirruptTv.ErrorView, accepts: ~w(html json)],
  pubsub: [name: KirruptTv.PubSub, adapter: Phoenix.PubSub.PG2],
  fanart_key: "e5b2ae915bf77dc6f0ebb1af149c27ce"

config :kirrupt_tv, KirruptTv.Endpoint, live_view: [signing_salt: "FglqWk3uhmjKfAGi"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:file, :line],
  metadata: [:request_id]

# Configures Sentry's Logger
config :sentry,
  use_error_logger: true,
  environment_name: :dev

config :phoenix, :json_library, Jason

config :arc,
  storage: Arc.Storage.Local

config :kirrupt_tv, KirruptTv.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: ConfigHelpers.get_env_with_fallback("MYSQL_USER", "root"),
  password: ConfigHelpers.get_env_with_fallback("MYSQL_PASS", "password"),
  database: ConfigHelpers.get_env_with_fallback("MYSQL_DB", "kirrupt"),
  hostname: ConfigHelpers.get_env_with_fallback("MYSQL_HOST", "localhost"),
  pool_size: 10

config :kirrupt_tv, KirruptTv.Scheduler,
  jobs: [
    {{:extended, "*/30"}, {Model.Show, :update_any_show, []}},
    {{:extended, "@daily"}, {Model.SearchShow, :update_all, []}}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
