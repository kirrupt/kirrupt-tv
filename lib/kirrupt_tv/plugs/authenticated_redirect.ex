defmodule KirruptTv.Plugs.Authenticated.Redirect do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _) do
    conn = fetch_session(conn)

    if conn.assigns[:current_user] do
      conn
      |> Phoenix.Controller.redirect(to: KirruptTv.Router.Helpers.recent_path(conn, :index))
      |> halt
    else
      conn
    end
  end
end
