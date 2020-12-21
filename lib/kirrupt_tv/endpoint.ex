defmodule KirruptTv.Endpoint do
  # Apply 'cache forever' caching headers for resources that will never change.
  def caching_headers(conn, args) do
    [head|_] = conn.path_info

    case should_cache_forever(head) do
      true -> [{"cache-control", "public, max-age=31536000"}]
      false -> []
    end
  end

  def should_cache_forever("images"), do: true
  def should_cache_forever("favicon.ico"), do: true
  def should_cache_forever("shows"), do: true
  def should_cache_forever(_), do: false

  use Phoenix.Endpoint, otp_app: :kirrupt_tv

  socket "/socket", KirruptTv.UserSocket
  socket "/live", Phoenix.LiveView.Socket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :kirrupt_tv, gzip: false,
    only: ~w(fonts css-old js-old images shows favicon.ico robots.txt),
    headers: {__MODULE__, :caching_headers, [%{}]}
  
  plug Plug.Static,
    at: "/",
    from: "priv/dist",
    gzip: false,
    only: ~w(index.html manifest.json service-worker.js css fonts img js favicon.ico robots.txt),
    headers: {__MODULE__, :caching_headers, [%{}]}
    #only_matching: ["precache-manifest"]

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_kirrupt_tv_key",
    signing_salt: "s5XMKysn"

  plug KirruptTv.Router
end
