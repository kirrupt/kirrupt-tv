use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kirrupt_tv, KirruptTv.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :kirrupt_tv, KirruptTv.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: ConfigHelpers.get_env_with_fallback("MYSQL_USER", "root"),
  password: ConfigHelpers.get_env_with_fallback("MYSQL_PASS", "password"),
  database: ConfigHelpers.get_env_with_fallback("MYSQL_DB", "kirrupt_test"),
  hostname: ConfigHelpers.get_env_with_fallback("MYSQL_HOST", "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox
