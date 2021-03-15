use Mix.Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.

# Do not print debug messages in production
config :logger, level: :debug

config :kirrupt_tv, KirruptTv.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: {:system, "PORT"}],
  url: [host: {:system, "HOSTNAME"}, port: 80],
  cache_static_manifest: "priv/static/manifest.json"

config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  tags: %{
    env: "production"
  }

config :kirrupt_tv, KirruptTv.Scheduler,
  jobs: [
    {{:extended, "*/30"}, {Model.Show, :update_any_show, []}}
  ]
