defmodule KirruptTv.Plugs.Authenticated.Admin do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _) do
    conn = fetch_session(conn)
    not_logged_in_url = "/login"
    unless is_admin(conn.assigns[:current_user]) do
      conn |> Phoenix.Controller.redirect(to: not_logged_in_url) |> halt
    else
      conn
    end
  end

  def is_admin(nil), do: false
  def is_admin(user) do
    user.is_admin
  end
end
