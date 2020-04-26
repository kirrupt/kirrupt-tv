defmodule KirruptTv.Plugs.Authenticated.Admin do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _) do
    conn
    |> fetch_session
    |> admin_or_login
  end

  def admin_or_login(conn) do
    unless is_admin(conn.assigns[:current_user]) do
      conn |> Phoenix.Controller.redirect(to: KirruptTv.Router.Helpers.account_path(conn, :login)) |> halt
    else
      conn
    end
  end

  def is_admin(nil), do: false
  def is_admin(user) do
    user.is_admin
  end
end
