defmodule KirruptTv.Plugs.Authenticate do
  import Plug.Conn
  alias KirruptTv.Repo
  alias Model.User

  def init(options) do
    options
  end

  def call(conn, _) do
    conn = fetch_session(conn)
    assign(conn, :current_user, find_user(conn))
  end

  defp find_user(conn) do
    if auto_hash = Map.get(conn.req_cookies, "auto_hash") do
      Repo.get_by(User, auto_hash: auto_hash)
    end
  end

  def fake_user(user_id \\ nil) do
    if user_id != nil do
      Repo.get(User, user_id)
    end
  end
end
