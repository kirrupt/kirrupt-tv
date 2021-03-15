defmodule KirruptTv.Plugs.Authenticated do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _) do
    conn = fetch_session(conn)

    unless is_logged_in(conn.assigns[:current_user]) do
      case conn.private[:pipeline_name] do
        :browser ->
          conn
          |> Phoenix.Controller.redirect(to: KirruptTv.Router.Helpers.account_path(conn, :login))
          |> halt

        _ ->
          conn
          |> send_resp(401, "unauthorized")
          |> halt
      end
    else
      conn
    end
  end

  def is_logged_in(user_session) do
    case user_session do
      nil -> false
      _ -> true
    end
  end
end
