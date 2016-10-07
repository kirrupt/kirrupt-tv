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
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
